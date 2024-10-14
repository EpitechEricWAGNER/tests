import axios from "axios";

const API_URL = "http://localhost:4000/api";

interface ClockData {
    start: string | null;
    status: boolean;
}

const ClockManagerServices = {
    start: null as string | null,
    status: false,

    async refresh(userId: string): Promise<void> {
        try {
            const response = await axios.get<ClockData>(`${API_URL}/clock/${userId}`);
            this.start = response.data.start;
            this.status = response.data.status;
        } catch (error) {
            console.error("Error refreshing clock data:", error);
        }
    },

    async clock(userId: string): Promise<void> {
        try {
            const response = await axios.post<ClockData>(`${API_URL}/clock/${userId}`, {
                status: !this.status,
            });
            this.start = response.data.start;
            this.status = response.data.status;
        } catch (error) {
            console.error("Error updating clock data:", error);
        }
    },
};

export default ClockManagerServices;
