<script setup lang="ts">
import { computed, ref } from "vue";
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
import { Select } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { User } from "@/store";
import userService from "@/services/userService";
import { useRouter } from "vue-router";

const store = useStore();
const user = computed(() => store.getters.user);

const newUsername = ref<string>("");
const newEmail = ref<string>("");
const id = ref<string>(user.value.data.id);
const email = ref<string>(user.value.data.email);
const username = ref<string>(user.value.data.username);

const router = useRouter();

const updateUser = async () => {
    try {
        const userData = {
            id: id.value,
            username: newUsername.value || username.value,
            email: newEmail.value || email.value,
        };
        const user: User = await userService.updateUser(userData);
        store.commit("setUser", user);
    } catch (error) {
        console.error("Erreur lors de la recherche utilisateur:", error);
    }
};

const deleteUser = async () => {
    try {
        console.log("deleteUser" + id.value);
        const userData = {
            id: id.value,
        };
        const user: User = await userService.deleteUser(userData);
        store.commit("setUser", user);
        router.push("/");
    } catch (error) {
        console.error("Erreur lors de la recherche utilisateur:", error);
    }
};
</script>

<template>
    <div>
        <h3 class="text-lg font-medium">Profile</h3>
        <p class="text-sm text-muted-foreground">
            This is how others will see you on the site.
        </p>
    </div>
    <Separator />
    <form class="space-y-8">
        <FormField v-slot="{ componentField }" name="username">
            <FormItem>
                <FormLabel>Username</FormLabel>
                <FormControl>
                    <Input
                        type="text"
                        :placeholder="user.data.username"
                        v-bind="componentField"
                        v-model="newUsername"
                    />
                </FormControl>
                <FormDescription>
                    This is your public display name.
                </FormDescription>
                <FormMessage />
            </FormItem>
        </FormField>

        <FormField v-slot="{ componentField }" name="email">
            <FormItem>
                <FormLabel>Email</FormLabel>

                <Select v-bind="componentField">
                    <FormControl>
                        <Input
                            type="email"
                            :placeholder="user.data.email"
                            v-bind="componentField"
                            v-model="newEmail"
                        />
                    </FormControl>
                </Select>
                <FormDescription>
                    You can manage verified email addresses in your email
                    settings.
                </FormDescription>
                <FormMessage />
            </FormItem>
        </FormField>

        <div class="flex gap-2 justify-start">
            <Button type="button" @click="updateUser"> Update profile </Button>

            <Button type="button" @click="deleteUser" variant="destructive">
                Delete
            </Button>
        </div>
    </form>
</template>
