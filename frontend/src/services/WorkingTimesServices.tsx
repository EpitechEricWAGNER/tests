import axios from "axios";

const API_URL = "http://localhost:4000/api";

interface WorkingTimeData {
    userId: string;
    start: string;
    end: string;
}

export default {
    async createWorkingTime(workingTimeData: WorkingTimeData): Promise<any> {
        try {
            const response = await axios.post(
                `${API_URL}/workingtime/${workingTimeData.userId}`,
                {
                    workingtime: {
                        userId: workingTimeData.userId,
                        start: workingTimeData.start,
                        end: workingTimeData.end,
                    },
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error creating working time:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async updateWorkingTime(workingTimeId: string): Promise<any> {
        try {
            const response = await axios.put(
                `${API_URL}/workingtime/${workingTimeId}`
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error updating working time:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async deleteWorkingTime(workingTimeId: string): Promise<any> {
        try {
            const response = await axios.delete(
                `${API_URL}/workingtime/${workingTimeId}`
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error deleting working time:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async getWorkingTime(userId: string): Promise<any> {
        try {
            const response = await axios.get(
                `${API_URL}/workingtime/${userId}`
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error getting working time:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },
};