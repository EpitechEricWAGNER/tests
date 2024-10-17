import axios, { AxiosResponse } from "axios";

const API_URL = "http://localhost:4000/api";

interface ClockData {
    time: string;
    status: boolean;
    user: number;
}

interface Clock {
    id: number;
    time: string;
    status: boolean;
}

interface ClockResponse {
    data: Clock[];
}

export default {
    async clock(clockData: ClockData): Promise<ClockResponse> {
        try {
            const response: AxiosResponse<ClockResponse> = await axios.post(
                `${API_URL}/clocks/${clockData.user}`,
                {
                    time: clockData.time,
                    status: clockData.status,
                    user: clockData.user,
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error clocking in/out:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async getClocks(clockData: ClockData): Promise<ClockResponse> {
        try {
            const response: AxiosResponse<ClockResponse> = await axios.get(
                `${API_URL}/clocks/${clockData.user}`,
                {
                    params: {
                        time: clockData.time,
                        status: clockData.status,
                        user: clockData.user,
                    },
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error getting clocks:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },
};
