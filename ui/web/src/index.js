import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';
import { BrowserRouter } from 'react-router-dom';
import { AppProvider } from '@shopify/polaris';
import { ApolloProvider } from 'react-apollo';
import { ApolloClient } from 'apollo-client';
import { createHttpLink } from 'apollo-link-http';
import { setContext } from 'apollo-link-context';
import { InMemoryCache } from 'apollo-cache-inmemory';
import logo from './lib/img/everydae_logo.png';

const httpLink = createHttpLink({
  uri: 'http://localhost:3500',
  credentials: 'include',
});

const authLink = setContext((_, { headers }) => {
  const token =
    localStorage.getItem('loginToken') || localStorage.getItem('signupToken');
  return {
    headers: {
      ...headers,
      authorization: token
        ? `${process.env.REACT_APP_SECRET_TOKEN_ADDON} ${token}`
        : '',
    },
  };
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache(),
});

const theme = {
  colors: {
    topBar: {
      background: '#00338f',
    },
  },
  logo: {
    width: 124,
    topBarSource: logo,
    url: '/',
    accessibilityLabel: 'everydae',
  },
};

ReactDOM.render(
  <ApolloProvider client={client}>
    <AppProvider theme={theme}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </AppProvider>
  </ApolloProvider>,
  document.getElementById('root')
);

serviceWorker.unregister();
