export let usersQuery = `{
    user {
      userId:user_id
      email
      username
      score
      firstname
      lastname
      active
      password
    }
  }
`;

export let signUpMutation = `
    mutation signup($firstname: String, $lastname: String, $email: String, $password: String, $roleId: Int, $username: String){
        insert_user(objects: {firstname: $firstname, lastname: $lastname, email: $email, password: $password, role_id: $roleId, username: $username}) {
            returning {
                firstname
                lastname
                email
                userId:user_id
                roleId:role_id
                active
            }
        }
    }
`;

export let signInMutation = `
    query($email: String!) {
        user( where: {email: {_eq: $email}}) {
            userId:user_id
            firstname
            lastname
            password
            email
        }
    }
`;

export let deleteUserMutation = `
    mutation update_user($id: Int!) {
        update_user(
            where: {user_id: {_eq: $id}},
            _set: {active:false}
        ) {
            affected_rows
            returning {
                userId:user_id
                active
            }
        }
    }
`;
