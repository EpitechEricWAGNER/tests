import axios, { AxiosResponse }  from 'axios';

const API_URL = 'http://localhost:4000/api';

interface WorkingTimeData {
	id?: string;
	start: string;
	end: string;
	user: string;
}

interface WorkingTimeResponse {
	id: string;
	start: string;
	end: string;
	user: string;
}

export const workingtimeService = {
	async getAllWorkingTimes(userID, start, end) {
		try {
			const response = await axios.get(`${API_URL}/workingtime/${userID}`, {
				params: { start, end }
			});
			return response.data;
		} catch (error) {
			console.error('Error getting all working times:', error.response ? error.response.data : error.message);
			throw error;
		}
	},

	async getWorkingTimeById(userID, id) {
		try {
			const response = await axios.get(`${API_URL}/workingtime/${userID}/${id}`);
			return response.data;
		} catch (error) {
			console.error('Error getting working time:', error.response ? error.response.data : error.message);
			throw error;
		}
	},

	async createWorkingTime(WorkingTimeData: WorkingTimeData): Promise<WorkingTimeResponse> {
		try {
			const response: AxiosResponse<WorkingTimeResponse> = await axios.post(`${API_URL}/workingtime/${WorkingTimeData.user}`, {
				start: WorkingTimeData.start,
				end: WorkingTimeData.end,
			});
			return response.data;
		} catch (error: any) {
			console.error('Error creating Working time:', error.response ? error.response.data : error.message);
			throw error;
		}
	},

	async updateWorkingTime(id, workingTimeData) {
		try {
			const response = await axios.put(`${API_URL}/workingtime/${id}`, {
				start: workingTimeData.start,
				end: workingTimeData.end,
				user: workingTimeData.user
			});
			return response.data;
		} catch (error) {
			console.error('Error updating working time:', error.response ? error.response.data : error.message);
			throw error;
		}
	},

	async deleteWorkingTime(id) {
		try {
			const response = await axios.delete(`${API_URL}/workingtime/${id}`);
			return response.data;
		} catch (error) {
			console.error('Error deleting working time:', error.response ? error.response.data : error.message);
			throw error;
		}
	}
};

