import React from 'react';
import {
  Card,
  Frame,
  Layout,
  Loading,
  Navigation,
  SkeletonBodyText,
  SkeletonDisplayText,
  SkeletonPage,
  TextContainer,
  TopBar,
} from '@shopify/polaris';
import {
  CategoriesMajorMonotone,
  TextBlockMajorMonotone,
  QuestionMarkMajorMonotone,
  ConfettiMajorMonotone,
  HashtagMajorMonotone,
  SettingsMajorMonotone,
} from '@shopify/polaris-icons';
import { Switch, Route } from 'react-router-dom';
import Drills from '../Drills/';
import Signup from '../Signup/';
import UserList from '../Users/';

export default class Home extends React.Component {
  state = {
    isLoading: false,
    userMenuOpen: false,
    showMobileNavigation: false,
    modalActive: false,
    userName: this.props.user,
  };

  render() {
    const {
      isLoading,
      userMenuOpen,
      showMobileNavigation,
      userName,
    } = this.state;

    const userMenuActions = [
      {
        items: [
          {
            content: 'Logout',
            onAction: () => {
              localStorage.removeItem('loginToken');
              localStorage.removeItem('authUser');
              this.props.logOut();
            },
          },
        ],
      },
    ];

    const navigationUserMenuMarkup = (
      <Navigation.UserMenu
        actions={userMenuActions}
        name={userName}
        avatarInitials={userName.charAt(0)}
      />
    );

    const userMenuMarkup = (
      <TopBar.UserMenu
        actions={userMenuActions}
        name={userName}
        initials={userName.charAt(0)}
        open={userMenuOpen}
        onToggle={this.toggleState('userMenuOpen')}
      />
    );

    const topBarMarkup = (
      <TopBar
        showNavigationToggle={true}
        userMenu={userMenuMarkup}
        onNavigationToggle={this.toggleState('showMobileNavigation')}
      />
    );

    const navigationMarkup = (
      <Navigation location="/" userMenu={navigationUserMenuMarkup}>
        <Navigation.Section
          separator
          title="SAT"
          items={[
            {
              label: 'Drills',
              url: './drills',
              icon: CategoriesMajorMonotone,
              onClick: this.toggleState('isLoading'),
            },
            {
              label: 'Passages',
              icon: TextBlockMajorMonotone,
              onClick: this.toggleState('isLoading'),
            },
            {
              label: 'Questions',
              icon: QuestionMarkMajorMonotone,
              onClick: this.toggleState('isLoading'),
            },
            {
              label: 'Extra Credit',
              icon: ConfettiMajorMonotone,
              onClick: this.toggleState('isLoading'),
            },
            {
              label: 'Tags',
              icon: HashtagMajorMonotone,
              onClick: this.toggleState('isLoading'),
            },
          ]}
        />
        <div className="position-bottom">
          <Navigation.Section
            items={[
              {
                url: './userlist',
                label: 'Manage Users',
                icon: SettingsMajorMonotone,
              },
            ]}
          />
        </div>
      </Navigation>
    );

    const loadingMarkup = isLoading ? <Loading /> : null;

    const routes = (
      <Switch>
        <Route exact path="/" component={Drills} />
        <Route path="/createuser" component={Signup} />
        <Route path="/userlist" component={UserList} />
        <Route path="/drills" component={Drills} />
      </Switch>
    );

    const loadingPageMarkup = (
      <SkeletonPage>
        <Layout>
          <Layout.Section>
            <Card sectioned>
              <TextContainer>
                <SkeletonDisplayText size="small" />
                <SkeletonBodyText lines={9} />
              </TextContainer>
            </Card>
          </Layout.Section>
        </Layout>
      </SkeletonPage>
    );

    const pageMarkup = isLoading ? loadingPageMarkup : routes;

    return (
      <div>
        <Frame
          topBar={topBarMarkup}
          navigation={navigationMarkup}
          showMobileNavigation={showMobileNavigation}
          onNavigationDismiss={this.toggleState('showMobileNavigation')}
        >
          {loadingMarkup}
          {pageMarkup}
        </Frame>
      </div>
    );
  }

  toggleState = key => {
    return () => {
      this.setState(prevState => ({ [key]: !prevState[key] }));
    };
  };
}
