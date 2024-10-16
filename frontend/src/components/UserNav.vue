<script setup lang="ts">
import { computed, watch } from "vue";
import { useStore } from "vuex";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const store = useStore();
const user = computed(() => store.getters.user);

const logout = () => {
    store.commit("clearUser", user);
};

watch(user, (newUser: any) => {
    console.log("Utilisateur mis à jour:", newUser);
    console.log(JSON.stringify(newUser));
});
</script>

<template>
    <DropdownMenu>
        <DropdownMenuTrigger as-child>
            <Button variant="ghost" class="relative h-8 w-8 rounded-full">
                <Avatar class="h-8 w-8">
                    <AvatarFallback>{{
                        user ? user.data.username[0] : "N/A"
                    }}</AvatarFallback>
                </Avatar>
            </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent class="w-56" align="end">
            <DropdownMenuLabel class="font-normal flex">
                <div class="flex flex-col space-y-1">
                    <p class="text-sm font-medium leading-none">
                        {{ user ? user.data.username : "Aucun Utilisateur" }}
                    </p>
                    <p class="text-xs leading-none text-muted-foreground">
                        {{ user ? user.data.email : "Aucun Utilisateur" }}
                    </p>
                </div>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuGroup>
                <DropdownMenuItem>
                    <router-link to="/manage">Profile</router-link>
                </DropdownMenuItem>
            </DropdownMenuGroup>
            <DropdownMenuSeparator />
            <DropdownMenuItem @click="logout"> Log out </DropdownMenuItem>
        </DropdownMenuContent>
    </DropdownMenu>
</template>
