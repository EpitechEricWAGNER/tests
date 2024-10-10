<template>
    <div class="bg-gray-100 min-h-screen">
        <header class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div
                    class="flex justify-between items-center py-6 md:justify-start md:space-x-10"
                >
                    <div class="flex justify-start lg:w-0 lg:flex-1">
                        <h1 class="text-xl font-bold text-gray-900">
                            User Management
                        </h1>
                    </div>
                    <div v-if="!currentUser">
                        <!-- get user or view user select-->
                        <button
                            @click="toggleGetUser"
                            class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                        >
                            {{
                                currentUser ? currentUser.username : "Get User"
                            }}
                        </button>
                    </div>
                    <div v-else>
                        <h2 class="text-lg font-medium text-gray-900">
                            {{ currentUser.username + " " +currentUser.id }}
                        </h2>
                    </div>
                    <div
                        class="md:flex items-center justify-end md:flex-1 lg:w-0"
                    >
                        <button
                            @click="toggleUserPanel"
                            class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                        >
                            {{ currentUser ? "Manage User" : "Create User" }}
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <div
            v-if="showUserPanel"
            class="absolute inset-x-0 top-0 z-10 origin-top-right transform p-2 transition"
        >
            <div
                class="rounded-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5 divide-y-2 divide-gray-50"
            >
                <div class="px-5 pt-5 pb-6 space-y-6">
                    <div v-if="currentUser">
                        <h2 class="text-lg font-medium text-gray-900">
                            Current User: {{ currentUser.username }}
                        </h2>
                        <!-- update user -->
                        <form @submit.prevent="updateUser">
                            <div class="space-y-4">
                                <input
                                    v-model="currentUser.username"
                                    placeholder="Username"
                                    required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                />
                                <input
                                    v-model="currentUser.email"
                                    placeholder="Email"
                                    required
                                    type="email"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                />
                            </div>
                            <button
                                type="submit"
                                class="mt-5 w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                            >
                                Update User
                            </button>
                        </form>
                        <button
                            @click="deleteUser"
                            class="mt-3 w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-red-600 hover:bg-red-700"
                        >
                            Delete User
                        </button>
                        <button
                            @click="logout"
                            class="mt-3 w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-gray-700 bg-gray-200 hover:bg-gray-300"
                        >
                            Logout
                        </button>
                    </div>
                    <form v-else @submit.prevent="createUser">
                        <div class="space-y-4">
                            <input
                                v-model="newUser.username"
                                placeholder="Username"
                                required
                                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                            />
                            <input
                                v-model="newUser.email"
                                placeholder="Email"
                                required
                                type="email"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                            />
                        </div>
                        <button
                            type="submit"
                            class="mt-5 w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                        >
                            Create User
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div>
            <div
                v-if="showGetUser"
                class="absolute inset-x-0 top-0 z-10 origin-top-right transform p-2 transition"
            >
                <div
                    class="rounded-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5 divide-y-2 divide-gray-50"
                >
                    <div class="px-5 pt-5 pb-6 space-y-6">
                        <form @submit.prevent="getUser">
                            <div class="space-y-4">
                                <input
                                    v-model="newUser.username"
                                    placeholder="Username"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                />
                                <input
                                    v-model="newUser.email"
                                    placeholder="Email"
                                    type="email"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                />
                            </div>
                            <button
                                type="submit"
                                class="mt-5 w-full inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                            >
                                Get User
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import userService from "@/services/userService";

export default {
    data() {
        return {
            currentUser: null,
            showUserPanel: false,
            showGetUser: false,
            newUser: {
                username: "",
                email: "",
            },
        };
    },
    methods: {
        toggleUserPanel() {
            this.showUserPanel = !this.showUserPanel;
        },
        toggleGetUser() {
            this.showGetUser = !this.showGetUser;
        },
        async createUser() {
            try {
                const user = await userService.createUser(this.newUser);
                this.currentUser = user.data;
                this.newUser = { username: "", email: "" };
                this.showUserPanel = false;
            } catch (error) {
                console.error("Error creating user:", error);
            }
        },
        async getUser() {
            try {
                const user = await userService.getUser(
                    this.newUser.username,
                    this.newUser.email
                );
                this.currentUser = user.data;
                this.newUser = { username: "", email: "" };
                this.showGetUser = false;
            } catch (error) {
                console.error("Error getting user:", error);
            }
        },
        async updateUser() {
            try {
                const user = await userService.updateUser(
                    this.currentUser.id,
                    this.currentUser
                );
                this.currentUser = user.data;
                this.showUserPanel = false;
            } catch (error) {
                console.error("Error updating user:", error);
            }
        },
        async deleteUser() {
            try {
                await userService.deleteUser(this.currentUser.id);
                this.currentUser = null;
                this.showUserPanel = false;
            } catch (error) {
                console.error("Error deleting user:", error);
            }
        },
        logout() {
            this.currentUser = null;
            this.showUserPanel = false;
            localStorage.removeItem("currentUser");
        },
    },
    mounted() {
        const storedUser = localStorage.getItem("currentUser");
        if (storedUser) {
            this.currentUser = JSON.parse(storedUser);
        }
    },
};
</script>
