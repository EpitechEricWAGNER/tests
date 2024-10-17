<script setup lang="ts">
import { computed, onMounted, reactive } from "vue";
import clockService from "@/services/clockService";
import { useStore } from "vuex";

const store = useStore();
const user = computed(() => store.getters.user);

let clockIn: any[] = [];
let clockOut: any[] = [];

const workTime = reactive({
    hours: 0,
    minutes: 0,
});

const getClockForToday = async () => {
    try {
        const id = user.value.data.id;
        const clocks = await clockService.getClocks(id);
        for (let i = 0; i < clocks.data.length; i++) {
            let clock = clocks.data[i].time;
            let date = clock.split("T")[0];
            let hour = clock.split("T")[1].split(".")[0];
            const today = new Date().toISOString().split("T")[0];
            if (date === today) {
                if (clocks.data[i].status === true) {
                    clockIn.push(hour);
                } else {
                    clockOut.push(hour);
                }
            }
        }
        calculateTimeWork();
    } catch (error) {
        console.error("Error while fetching clock for today:", error);
        return null;
    }
};

const calculateTimeWork = () => {
    let totalMinutes = 0;
    for (let i = 0; i < clockOut.length; i++) {
        let clockOutHour = parseInt(clockOut[i].split(":")[0]);
        let clockOutMinute = parseInt(clockOut[i].split(":")[1]);
        let clockInHour = parseInt(clockIn[i].split(":")[0]);
        let clockInMinute = parseInt(clockIn[i].split(":")[1]);
        let diffHour = clockOutHour - clockInHour;
        let diffMinute = clockOutMinute - clockInMinute;
        totalMinutes += diffHour * 60 + diffMinute;
    }
    workTime.hours = Math.floor(totalMinutes / 60);
    workTime.minutes = totalMinutes % 60;
};

onMounted(() => {
    if (user.value !== null && user.value !== undefined && user.value !== "") {
        getClockForToday();
    }
});
</script>

<template>
    <div class="text-2xl font-bold">
        {{ workTime.hours }} hours {{ workTime.minutes }} minutes
    </div>
</template>
