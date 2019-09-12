const nameRegex = new RegExp('[a-zA-Z]+');
const emailRegex = new RegExp(
  '[a-zA-Z0-9._%+-]+@(everydae|learnwithorion).com$'
);
const passwordRegex = new RegExp(
  '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})'
);

/**************************************
 *              USER VALIDATIONS
 **************************************/
/*
 * This functions validates the input arguments (for the auth form) using regex.
 * @param Object that contains values of signup form input fields
 * @return Array of Strings with errors message if input(s) invalid. Empty otherwise
 */
function validateAuthInputs(args) {
  let validationMsgs = {};

  if (!args.firstname.match(nameRegex)) {
    validationMsgs.firstname =
      'Invalid first name. Must not be empty and contains letters only';
  }
  if (!args.lastname.match(nameRegex)) {
    validationMsgs.lastname =
      'Invalid last name. Must not be empty and contains letters only';
  }
  if (!args.email.match(emailRegex)) {
    validationMsgs.email =
      'Invalid email. Must end with everydae.com or learnwithorion.com';
  }
  if (!args.password.match(passwordRegex)) {
    validationMsgs.password =
      'Invalid password. Must contain at least 8 characters, at least 1 lowercase alphabetical character, at least 1 uppercase, at least 1 numeric character, at least one special character.<br/>';
  }
  return validationMsgs;
}

/*
 * This functions validates the input arguments (for the signin form) using regex.
 * @param Object that contains values of signin form input fields
 * @return Array of Strings with errors message if input(s) invalid. Empty otherwise
 */
function validateSigninInputs(args) {
  let validationMsgs = {};

  if (!args.email.match(emailRegex)) {
    validationMsgs.email =
      'Invalid email. Must end with everydae.com or learnwithorion.com';
  }
  if (!args.password.match(passwordRegex)) {
    validationMsgs.password =
      'Invalid password. Must contain at least 8 characters, at least 1 lowercase alphabetical character, at least 1 uppercase, at least 1 numeric character, at least one special character.<br/>';
  }
  return validationMsgs;
}

function validateDeleteInput(id) {
  let validationMsgs = {};
  if (!(typeof id === 'number') || id < 1) {
    validationMsgs.id = 'Invalid id. It is not a valid number';
  }
  return validationMsgs;
}

module.exports = {
  validateAuthInputs,
  validateSigninInputs,
  validateDeleteInput,
};
