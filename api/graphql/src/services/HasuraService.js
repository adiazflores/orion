import BaseHTTPService from './BaseService';

export default BaseHTTPService.define(
  {
    hostname: process.env.HASURA_API_URL,
    resource: '/v1/graphql',
  },
  {
    async gqlPost(query) {
      try {
        const apiRequest = this.request.post('');
        apiRequest.set('Content-Type', 'application/json');
        const request = await apiRequest.send(query);
        return JSON.parse(request.text);
      } catch (e) {
        console.error(e);
      }
    },
  }
);
