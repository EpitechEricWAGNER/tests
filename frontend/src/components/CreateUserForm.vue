<script setup lang="ts">
import { ref } from "vue";
import { useStore } from "vuex";
import { Input } from "@/components/ui/input";
import {
    FormControl,
    FormDescription,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { User } from "@/store";
import userService from "@/services/userService";

const store = useStore();
const newUsername = ref<string>("");
const newEmail = ref<string>("");
const successMessage = ref<string>(""); // Nouveau ref pour le message de réussite

const createUser = async () => {
    try {
        const userData = {
            username: newUsername.value,
            email: newEmail.value,
        };
        const user: User = await userService.createUser(userData);
        store.commit("setUser", user);
        successMessage.value = "User created successfully !"; 
        newUsername.value = "";
        newEmail.value = "";
    } catch (error) {
        console.error("Erreur lors de la création de l'utilisateur:", error);
    }
};
</script>

<template>
  <div>
        <h3 class="text-lg font-medium">Create User</h3>
        <p class="text-sm text-muted-foreground">
            Create a new user.
        </p>
    </div>
    <Separator />
    <form class="space-y-8" @submit.prevent="createUser">
        <FormField v-slot="{ componentField }" name="username">
            <FormItem>
                <FormLabel>Username</FormLabel>
                <FormControl>
                    <Input
                        type="text"
                        placeholder="Enter username"
                        v-bind="componentField"
                        v-model="newUsername"
                    />
                </FormControl>
                <FormDescription>
                    This will be the user's public display name.
                </FormDescription>
                <FormMessage />
            </FormItem>
        </FormField>

        <FormField v-slot="{ componentField }" name="email">
            <FormItem>
                <FormLabel>Email</FormLabel>
                <FormControl>
                    <Input
                        type="email"
                        placeholder="Enter email"
                        v-bind="componentField"
                        v-model="newEmail"
                    />
                </FormControl>
                <FormDescription>
                    The user's email address.
                </FormDescription>
                <FormMessage />
            </FormItem>
        </FormField>

        <div class="flex gap-2 justify-start">
            <Button type="submit"> Create User </Button>
        </div>

        <div v-if="successMessage" class="mt-4 text-green-600">
            {{ successMessage }}
        </div>
    </form>
</template>
