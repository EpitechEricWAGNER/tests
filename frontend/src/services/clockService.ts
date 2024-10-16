import axios from "axios";

const API_URL = "http://localhost:4000/api";

interface ClockManager {
    startDateTime: Date | null;
    clockIn: boolean;
    clock: (userID: number) => Promise<void>;
    getClocks: (
        userID: number
    ) => Promise<{ status: boolean; time: Date; user: Number }[]>;
}

const clockManager: ClockManager = {
    startDateTime: null,
    clockIn: true,
    async clock(userID: number) {
        try {
            this.clockIn = !this.clockIn;
            const clockData = {
                time: new Date().toISOString(),
                status: this.clockIn,
                user: userID,
            };

            const response = await axios.post(
                `${API_URL}/clocks/${userID}`,
                clockData
            );
            this.startDateTime = this.clockIn ? null : new Date();
            return response.data;
        } catch (error: any) {
            console.error(
                "Error clocking in/out:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async getClocks(
        userID: number
    ): Promise<{ status: boolean; time: Date; user: Number }[]> {
        try {
            const response = await axios.get(`${API_URL}/clocks/${userID}`);
            let clock = response.data.data[response.data.data.length - 1];
            this.clockIn = clock?.status ?? false;
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

export default clockManager;
