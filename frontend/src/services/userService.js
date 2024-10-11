import axios from 'axios';

const API_URL = 'http://localhost:4000/api';

export default {
  async createUser(userData) {
    try {
      // Assurez-vous que les données envoyées sont dans le bon format
      const response = await axios.post(`${API_URL}/users`, {
        user: {
          username: userData.username,
          email: userData.email,
        }
      });
      return response.data;
    } catch (error) {
      console.error('Error creating user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },

  async deleteUser(userId) {
    try {
      const response = await axios.delete(`${API_URL}/users/${userId}`);
      return response.data;
    } catch (error) {
      console.error('Error deleting user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },
  
  async updateUser(userId, userData) {  
    try {
      const response = await axios.put(`${API_URL}/users/${userId}`, {
        user: {
          username: userData.username,
          email: userData.email,
        }
      });
      return response.data;
    }
    catch (error) {
      console.error('Error updating user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },
  async getUser(username, email) {
    try {
      const response = await axios.get(`${API_URL}/users?email=${email}&username=${username}`);
      return response.data;
    }
    catch (error) {
      console.error('Error getting user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },
};

