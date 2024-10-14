import axios, { AxiosResponse } from "axios";

const API_URL = "http://localhost:4000/api";

interface UserData {
    id?: string;
    username: string;
    email: string;
}

interface UserResponse {
    id: string;
    username: string;
    email: string;
}

export default {
    async createUser(userData: UserData): Promise<UserResponse> {
        try {
            const response: AxiosResponse<UserResponse> = await axios.post(
                `${API_URL}/users`,
                {
                    user: {
                        username: userData.username,
                        email: userData.email,
                    },
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error creating user:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async getUser(userData: Partial<UserData>): Promise<UserResponse> {
        try {
            const response: AxiosResponse<UserResponse> = await axios.get(
                `${API_URL}/users`,
                {
                    params: {
                        email: userData.email,
                        username: userData.username,
                    },
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error getting user:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async updateUser(userData: UserData): Promise<UserResponse> {
        try {
            const response: AxiosResponse<UserResponse> = await axios.put(
                `${API_URL}/users/${userData.id}`,
                {
                    user: {
                        username: userData.username,
                        email: userData.email,
                    },
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error updating user:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },

    async deleteUser(userData: Partial<UserData>): Promise<UserResponse> {
        try {
            const response: AxiosResponse<UserResponse> = await axios.delete(
                `${API_URL}/users/${userData.id}`,
                {
                    params: {
                        userID: userData.id,
                    },
                }
            );
            return response.data;
        } catch (error: any) {
            console.error(
                "Error deleting user:",
                error.response ? error.response.data : error.message
            );
            throw error;
        }
    },
};
