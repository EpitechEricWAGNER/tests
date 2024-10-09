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
  }
};

