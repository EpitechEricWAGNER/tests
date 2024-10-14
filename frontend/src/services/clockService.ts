import axios from 'axios';

const API_URL = 'http://localhost:4000/api';

interface ClockManager {
    startDateTime: Date | null;
    clockIn: boolean;
    refresh: (userID: number) => Promise<void>;
    clock: (userID: number) => Promise<void>;
}

const clockManager: ClockManager = {
    startDateTime: null,
    clockIn: false,

    async refresh(userID :number) {
        try {
            const response = await axios.get(`${API_URL}/clocks/${userID}`);
        } catch (error) {
            console.error('Error refreshing clock data:', error.response ? error.response.data : error.message);
            throw error;
        }
    },

		async clock(userID :number) {
			try {
				const clockData = {
					time: new Date().toISOString(),
					status: this.clockIn, 
					user: userID
				};
				console.log(clockData);

				const response = await axios.post(`${API_URL}/clocks/${userID}`, clockData);
				this.startDateTime = this.clockIn ? null : new Date();
				this.clockIn = !this.clockIn;
				return response.data;
			} catch (error) {
				console.error('Error clocking in/out:', error.response ? error.response.data : error.message);
				throw error;
			}
		}
};

export default clockManager;
