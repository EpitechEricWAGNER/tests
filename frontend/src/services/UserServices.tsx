import axios from 'axios';

const API_URL = 'http://localhost:4000/api';

interface UserData {
  username: string;
  email: string;
}

export default {
  async createUser(userData: UserData): Promise<any> {
    try {
      const response = await axios.post(`${API_URL}/users`, {
        user: {
          username: userData.username,
          email: userData.email,
        }
      });
      return response.data;
    } catch (error: any) {
      console.error('Error creating user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },

  async deleteUser(userId: string): Promise<any> {
    try {
      const response = await axios.delete(`${API_URL}/users/${userId}`);
      return response.data;
    } catch (error: any) {
      console.error('Error deleting user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },
  
  async updateUser(userId: string, userData: UserData): Promise<any> {  
    try {
      const response = await axios.put(`${API_URL}/users/${userId}`, {
        user: {
          username: userData.username,
          email: userData.email,
        }
      });
      return response.data;
    } catch (error: any) {
      console.error('Error updating user:', error.response ? error.response.data : error.message);
      throw error;
    }
  },

  async getUser(username?: string, email?: string): Promise<any> {
  try {
    // Construire dynamiquement l'URL avec les paramètres présents
    const params = new URLSearchParams();
    if (email) params.append('email', email);
    if (username) params.append('username', username);

    const response = await axios.get(`${API_URL}/users?${params.toString()}`);
    console.log('response:', response.data);
    return response.data;
  } catch (error: any) {
    console.error('Error getting user:', error.response ? error.response.data : error.message);
    throw error;
  }
}

};
