import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { TextField } from '@shopify/polaris';

class Input extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: props.value,
    };
  }

  handleChange = value => {
    this.setState({ value });
  };

  render() {
    return (
      <React.Fragment>
        <TextField
          label={this.props.name}
          value={this.state.value}
          onChange={this.handleChange}
        />
      </React.Fragment>
    );
  }
}

Input.propTypes = {
  name: PropTypes.string.isRequired,
  value: PropTypes.any,
  required: PropTypes.bool,
};

Input.defaultProps = {
  required: false,
};

export default Input;
