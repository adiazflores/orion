import React from 'react';
import {
  Card,
  DataTable,
  Avatar,
  TextStyle,
  Icon,
  Page,
} from '@shopify/polaris';
import { DeleteMajorMonotone } from '@shopify/polaris-icons';
import './UserList.scss';
import { Query } from 'react-apollo';
import gql from 'graphql-tag';
import { withRouter } from 'react-router-dom';

const GET_USERS = gql`
  {
    users {
      email
      userId
      firstname
      lastname
      active
    }
  }
`;

function UserList(props) {
  return (
    <Query query={GET_USERS}>
      {({ data, loading, error }) => {
        if (loading) return 'Loading...';
        if (error) return <p>ERROR</p>;

        const renderRows = () => {
          return data.users.map(user => {
            if (user.active) {
              return [
                <Avatar customer name={user.firstname} size="medium" />,
                user.firstname,
                user.email,
                'Admin',
                <Icon source={DeleteMajorMonotone} color="inkLightest" />,
              ];
            } else {
              return [];
            }
          });
        };

        return (
          <div className="UserList">
            <Page
              title="Manage Users"
              primaryAction={{
                content: '+ New User',
                onAction: () => {
                  return props.history.push('/createuser');
                },
              }}
            >
              <Card sectioned>
                <DataTable
                  columnContentTypes={['text', 'text', 'text', 'text', 'text']}
                  headings={[
                    '',
                    <h3>
                      <TextStyle variation="strong">Name</TextStyle>
                    </h3>,
                    <h3>
                      <TextStyle variation="strong">Email</TextStyle>
                    </h3>,
                    <h3>
                      <TextStyle variation="strong">Role</TextStyle>
                    </h3>,
                    <h3>
                      <TextStyle variation="strong" />
                    </h3>,
                  ]}
                  rows={renderRows()}
                />
              </Card>
            </Page>
          </div>
        );
      }}
    </Query>
  );
}
export default withRouter(UserList);
