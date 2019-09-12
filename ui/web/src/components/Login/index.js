import React, { Component } from 'react';
import {
  Frame,
  Form,
  FormLayout,
  TopBar,
  Card,
  Banner,
  Button,
  TextField,
} from '@shopify/polaris';
import gql from 'graphql-tag';
import { Mutation } from 'react-apollo';
import { Link } from 'react-router-dom';

import './Login.scss';

const LOGIN = gql`
  mutation LOGIN($email: String!, $password: String!) {
    signIn(email: $email, password: $password) {
      token
      user {
        firstname
        lastname
      }
    }
  }
`;

class Login extends Component {
  constructor(props) {
    super(props);
    this.state = {
      email: '',
      password: '',
    };
  }

  renderForm(error) {
    const { email, password } = this.state;

    return (
      <FormLayout>
        <TextField
          value={email}
          onChange={this.handleChange('email')}
          label="Email"
          type="email"
          pattern="[a-zA-Z0-9._%+-]+@(everydae|learnwithorion).com$"
          placeholder="Your email goes here."
        />

        <TextField
          value={password}
          onChange={this.handleChange('password')}
          label="Password"
          type="password"
          placeholder="Keep it secret. Keep it safe."
        />

        <Button primary submit>
          Log In
        </Button>

        {error && (
          <Banner status="critical">
            <p>Oops! You sure about that?</p>
          </Banner>
        )}

        <Link to="/signup">Forgot password?</Link>
      </FormLayout>
    );
  }

  handleSubmit = async (e, login) => {
    e.preventDefault();
    login({ variables: { ...this.state } });
  };

  handleChange = field => {
    return value => this.setState({ [field]: value });
  };

  catchData = data => {
    const { token } = data.signIn;
    localStorage.setItem('loginToken', token);
    localStorage.setItem('authUser', data.signIn.user.firstname);
    this.props.setAuthUser(data.signIn.user.firstname, token);
  };

  catchError = error => {
    console.log(error);
  };

  render() {
    return (
      <Frame topBar={<TopBar />}>
        <Mutation mutation={LOGIN} onCompleted={data => this.catchData(data)}>
          {(login, { data, error }) => {
            //if(error) this.catchError(error);
            return (
              <div className="Login">
                <Card title="Log In" sectioned>
                  <Form onSubmit={e => this.handleSubmit(e, login)}>
                    {this.renderForm(error)}
                  </Form>
                </Card>
              </div>
            );
          }}
        </Mutation>
      </Frame>
    );
  }
}

export default Login;
