import axios, { AxiosResponse } from 'axios';

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
    async getAllWorkingTimes(userID: string, start: string, end: string): Promise<WorkingTimeResponse[]> {
        try {
            const response = await axios.get(`${API_URL}/workingtime/${userID}`, {
                params: { start, end }
            });
            return response.data.data;
        } catch (error: unknown) {
            const errMessage = error instanceof Error ? error.message : 'Unknown error';
            console.error('Error getting all working times:', errMessage);
            throw error;
        }
    },

    async getWorkingTimeById(userID: string, id: string): Promise<WorkingTimeResponse> {
        try {
            const response = await axios.get(`${API_URL}/workingtime/${userID}/${id}`);
            return response.data;
        } catch (error: unknown) {
            const errMessage = error instanceof Error ? error.message : 'Unknown error';
            console.error('Error getting working time:', errMessage);
            throw error;
        }
    },

    async createWorkingTime(workingTimeData: WorkingTimeData): Promise<WorkingTimeResponse> {
        try {
            const response: AxiosResponse<WorkingTimeResponse> = await axios.post(`${API_URL}/workingtime/${workingTimeData.user}`, {
                start: workingTimeData.start,
                end: workingTimeData.end,
            });
            return response.data;
        } catch (error: unknown) {
            const errMessage = error instanceof Error ? error.message : 'Unknown error';
            console.error('Error creating Working time:', errMessage);
            throw error;
        }
    },

    async updateWorkingTime(id: string, workingTimeData: WorkingTimeData): Promise<WorkingTimeResponse> {
        try {
            const response = await axios.put(`${API_URL}/workingtime/${id}`, {
                start: workingTimeData.start,
                end: workingTimeData.end,
                user: workingTimeData.user
            });
            return response.data;
        } catch (error: unknown) {
            const errMessage = error instanceof Error ? error.message : 'Unknown error';
            console.error('Error updating working time:', errMessage);
            throw error;
        }
    },

    async deleteWorkingTime(id: string): Promise<void> {
        try {
            const response = await axios.delete(`${API_URL}/workingtime/${id}`);
            return response.data;
        } catch (error: unknown) {
            const errMessage = error instanceof Error ? error.message : 'Unknown error';
            console.error('Error deleting working time:', errMessage);
            throw error;
        }
    }
};
