import axios from 'axios';

const API_URL = 'http://localhost:4000/api';

export default {
  async createUser(userData) {
    const response = await axios.post(`${API_URL}/users`, userData);
    return response.data;
  },

  async updateUser(userId, userData) {
    const response = await axios.put(`${API_URL}/users/${userId}`, userData);
    return response.data;
  },

  async getUser(userId) {
    const response = await axios.get(`${API_URL}/users/${userId}`);
    return response.data;
  },

  async deleteUser(userId) {
    const response = await axios.delete(`${API_URL}/users/${userId}`);
    return response.data;
  }
};
