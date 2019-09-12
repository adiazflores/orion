import * as superagent from 'superagent';

// Massage all superagent errors to show the bad request's response body
const request = superagent.agent().ok(res => {
  if (res.status < 400 && res.status >= 200) {
    return true;
  }
  console.log(JSON.stringify(res.body.errors, null, 3));
  throw new Error(res.body.errors || res.body);
});

class BaseHTTPService {
  /**
   * Set up service's state
   * @param {string} options.hostname
   * @param {string} options.resource
   * @param {Object} childMethods
   */
  constructor({ hostname, resource }, childMethods = {}) {
    this.hostname = hostname;
    this.resource = resource;
    this.apiUrl = hostname ? `${hostname}${resource}` : '';

    // Auto bind all functions to 'this'
    for (const key of Object.getOwnPropertyNames(this.constructor.prototype)) {
      const val = this[key];

      if (key !== 'constructor' && typeof val === 'function') {
        this[key] = val.bind(this);
      }
    }

    for (const k in childMethods) {
      if (typeof childMethods[k] === 'function') {
        this[k] = childMethods[k].bind(this);
      }
    }
  }

  /**
   * Create an instance of this class
   * @param  {...*} args
   * @return {this}
   */
  static define(...args) {
    return new BaseHTTPService(...args);
  }

  /**
   * Retrieve a list of records
   */
  async find() {
    try {
      const apiRequest = request.get(this.apiUrl);
      const response = await apiRequest;
      return response.body;
    } catch (e) {
      console.log(e);
    }
  }

  /**
   * Retrieve a single record by ID
   * @param {string} id
   */
  async findById(id) {
    try {
      const apiRequest = request.get(`${this.apiUrl}/${id}`);
      const response = await apiRequest;
      return response;
    } catch (e) {
      console.log(e);
    }
  }

  /**
   * Getter method that returns an object of methods.
   * These request methods will return superagent objects for executing
   * arbitrary requests against the service
   * @return {Object}
   */
  get request() {
    return {
      get: routePath => request.get(`${this.apiUrl}${routePath}`),
      put: routePath => request.put(`${this.apiUrl}${routePath}`),
      post: routePath => request.post(`${this.apiUrl}${routePath}`),
      patch: routePath => request.patch(`${this.apiUrl}${routePath}`),
      delete: routePath => request.delete(`${this.apiUrl}${routePath}`),
    };
  }
}

export default BaseHTTPService;
