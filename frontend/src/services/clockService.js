import axios from 'axios';

const API_URL = 'http://localhost:4000/api';

export const clocksService = {
	async getClocks(userID) {
		try {
			const response = await axios.get(`${API_URL}/clocks/${userID}`);
			return response.data;
		} catch (error) {
			console.error('Error getting clocks:', error.response ? error.response.data : error.message);
			throw error;
		}
	},

	async createClock(userID, clockData) {
		try {
			const response = await axios.post(`${API_URL}/clocks/${userID}`, {
				time: clockData.time,
				status: clockData.status,
				user: clockData.user
			});
			return response.data;
		} catch (error) {
			console.error('Error creating clock:', error.response ? error.response.data : error.message);
			throw error;
		}
	}
};

