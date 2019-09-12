import HasuraService from '../../services/HasuraService';
import { AuthenticationError } from 'apollo-server';
import {
  usersQuery,
  signUpMutation,
  signInMutation,
  deleteUserMutation,
} from './user.query';
import {
  validateAuthInputs,
  validateSigninInputs,
  validateDeleteInput,
} from '../../utils/validations';
import { createToken } from '../../utils/token';
import bcrypt from 'bcryptjs';
import { UserInputError } from 'apollo-server';

/**************************************
 *              QUERY
 **************************************/
const users = async (_, args, context) => {
  if (!context.userId)
    throw new AuthenticationError('Authentication is required');

  const query = {
    query: usersQuery,
  };

  const users = await HasuraService.gqlPost(query).then(res => {
    return res.data.user ? res.data.user : null;
  });

  return users;
};

/**************************************
 *              MUTATION
 **************************************/
// `input` contains the field from the NewUserInput type defined in the user schema
// If we use `args` instead of `{ input }`, then we need to do `args.input`
const signUp = async (parent, { input }, context) => {
  let validationErrors = validateAuthInputs(input);

  if (Object.keys(validationErrors).length > 0) {
    throw new UserInputError('Failed to signup due to validation errors', {
      validationErrors,
    });
  }

  const password = await bcrypt.hash(input.password, 10);

  const mutation = {
    query: signUpMutation,
    variables: {
      firstname: input.firstname,
      lastname: input.lastname,
      email: input.email,
      password: password,
      roleId: input.roleId,
      username: input.username,
    },
  };

  const User = await HasuraService.gqlPost(mutation).then(res => {
    if (res.errors && res.errors.length > 0) {
      throw new Error(res.errors[0].message);
    }
    return res.data.insert_user.returning[0];
  });

  const token = createToken({ userId: User.userId });

  return {
    token: token,
    user: User,
  };
};

const signIn = async (parent, args, context) => {
  let validationErrors = validateSigninInputs(args);

  if (Object.keys(validationErrors).length > 0) {
    throw new UserInputError('Failed to signin due to validation errors', {
      validationErrors,
    });
  }

  const query = {
    query: signInMutation,
    variables: {
      email: args.email,
    },
  };

  let user = await HasuraService.gqlPost(query);

  if (user.errors && user.errors.length > 0) {
    throw new Error(user.errors[0].message);
  } else if (user.data.user.length === 0) {
    throw new Error('No such user: ' + args.email);
  }

  user = user.data.user[0];

  const valid = await bcrypt.compare(args.password, user.password);
  if (!valid) {
    throw new Error('Invalid password');
  }

  const token = createToken({ userId: user.userId });

  return {
    token: token,
    user: user,
  };
};

const deleteUser = async (parent, args, context) => {
  let validationErrors = validateDeleteInput(args.id);
  if (Object.keys(validationErrors).length > 0) {
    throw new UserInputError('Failed to delete user due to validation errors', {
      validationErrors,
    });
  }

  const query = {
    query: deleteUserMutation,
    variables: {
      id: args.id,
    },
  };
  const user = await HasuraService.gqlPost(query).then(res => {
    return res.data.update_user.returning[0];
  });

  if (!user) {
    throw new Error('No such user found');
  }
  return user;
};

export default {
  Query: {
    users,
  },
  Mutation: {
    signUp,
    signIn,
    deleteUser,
  },
};
