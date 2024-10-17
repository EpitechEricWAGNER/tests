<script setup lang="ts">
import { Button } from "@/components/ui/button";
import { computed, onMounted } from "vue";
import clockService from "@/services/clockService";
import { useStore } from "vuex";
import { ref } from "vue";

const store = useStore();
const user = computed(() => store.getters.user);
const statusBtn = ref(false);

const getClock = async () => {
    try {
        const id = user.value.data.id;
        const response = await clockService.getClocks(id);
        const clocks = response.data;
        if (clocks.length > 0) {
            statusBtn.value = clocks[clocks.length - 1].status;
        }
        return clocks;
    } catch (error) {
        console.error("Erreur lors de la récupération de l'horloge:", error);
        return null;
    }
};

const createClock = async () => {
    const status = await getClock();
    console.log("Status:", status);
    try {
        statusBtn.value = !statusBtn.value;
        const id = user.value.data.id;
        await clockService.clock(id);
    } catch (error) {
        console.error("Erreur lors de la création de l'horloge:", error);
    }
};

onMounted(() => {
    if (user.value !== null && user.value !== undefined && user.value !== "") {
        getClock();
    }
});
</script>

<template>
    <Button
        :class="[
            statusBtn
                ? 'bg-green-500 hover:bg-green-700'
                : 'bg-red-500 hover:bg-red-700',
        ]"
        @click="createClock"
        >Clock</Button
    >
</template>
