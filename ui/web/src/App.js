import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import './App.css';
import Login from './components/Login/';
import Home from './components/Home/';
class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      authUser: '',
      token: '',
    };
  }

  componentDidMount() {
    this.setState({
      //temporary use of localStorage. Replace with cookie
      token: localStorage['loginToken'],
      authUser: localStorage['authUser'],
    });
  }

  setAuthUser = (name, token) => {
    this.setState({
      authUser: name,
      token: token,
    });
  };

  logOut = () => {
    this.setState({
      authUser: '',
      token: '',
    });
  };

  render() {
    return (
      <>
        {this.state.token ? (
          <Home user={this.state.authUser} logOut={this.logOut} />
        ) : (
          <Login setAuthUser={this.setAuthUser} />
        )}
      </>
    );
  }
}

export default withRouter(App);
