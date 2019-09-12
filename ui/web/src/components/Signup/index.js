import React, { Component } from 'react';
import './Signup.scss';
import {
  Card,
  Button,
  Form,
  FormLayout,
  TextField,
  Banner,
} from '@shopify/polaris';
import { Mutation } from 'react-apollo';
import gql from 'graphql-tag';
import { withRouter } from 'react-router-dom';

const REGISTER = gql`
  mutation Register($input: NewUserInput!) {
    signUp(input: $input) {
      token
      user {
        firstname
        lastname
        email
        userId
      }
      validationMsg
    }
  }
`;

class Signup extends Component {
  constructor(props) {
    super(props);
    this.state = {
      firstname: '',
      lastname: '',
      email: '',
      password: '',
      confirm_password: '',
      roleId: 1,
      validationMsg: '',
    };
  }

  renderForm() {
    const {
      firstname,
      lastname,
      email,
      password,
      confirm_password,
    } = this.state;

    return (
      <FormLayout>
        <TextField
          value={firstname}
          onChange={this.handleChange('firstname')}
          label="First Name"
          type="text"
          pattern="[a-zA-Z]+"
        />

        <TextField
          value={lastname}
          onChange={this.handleChange('lastname')}
          label="Last Name"
          type="text"
          pattern="[a-zA-Z]+"
        />

        <TextField
          value={email}
          onChange={this.handleChange('email')}
          label="Email"
          type="email"
          pattern="[a-zA-Z0-9._%+-]+@(everydae|learnwithorion).com$"
        />

        <TextField
          value={password}
          onChange={this.handleChange('password')}
          label="Password"
          type="password"
          // pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})"
          helpText={
            <span>
              The password must contain at least 8 characters, at least 1
              lowercase alphabetical character, at least 1 uppercase, at least 1
              numeric character, at least one special character.
            </span>
          }
        />

        <TextField
          value={confirm_password}
          onChange={this.handleChange('confirm_password')}
          label="Confirm Password"
          type="password"
          // pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})"
        />

        <Button primary submit>
          Submit
        </Button>

        {this.state.validationMsg && (
          <Banner title="There is an error in the inputs" status="critical">
            <p>{this.state.validationMsg}</p>
          </Banner>
        )}
      </FormLayout>
    );
  }

  handleSubmit = (e, signup) => {
    e.preventDefault();
    if (this.state.password === this.state.confirm_password) {
      let input = { ...this.state };
      delete input.confirm_password;
      delete input.validationMsg;
      signup({ variables: { input } });
    } else {
      alert('Passwords not match');
    }
  };

  handleChange = field => {
    return value => this.setState({ [field]: value });
  };

  catchData = data => {
    if (data.signUp.validationMsg) {
      this.setState({
        validationMsg: data.signUp.validationMsg,
      });
    } else {
      const token = data.signUp.token;
      localStorage.setItem(`signupToken_${data.signUp.user.userId}`, token);
      return this.props.history.push('/userlist');
    }
  };

  catchError = error => {
    console.log(error);
  };

  render() {
    return (
      <Mutation mutation={REGISTER}>
        {(signup, { data, error }) => {
          if (data) this.catchData(data);
          if (error) this.catchError(error);
          return (
            <Card title="Create a new user for EVERYDAE" sectioned>
              <Form onSubmit={e => this.handleSubmit(e, signup)}>
                {this.renderForm()}
              </Form>
            </Card>
          );
        }}
      </Mutation>
    );
  }
}

export default withRouter(Signup);
