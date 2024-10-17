<script setup lang="ts">
import OverviewMonth from "@/components/OverviewMonth.vue";
import MainNav from "@/components/MainNav.vue";
import DateRangePicker from "@/components/DateRangePicker.vue";
import RecentSales from "@/components/RecentSales.vue";
import Search from "@/components/Search.vue";
import UserNav from "@/components/UserNav.vue";
import { useStore } from "vuex";
import { workingtimeService } from "@/services/workingtimeService";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { computed, watch, ref } from "vue";

const store = useStore();
const user = computed(() => store.getters.user);

const userId = ref<string>("");
const username = ref<string>("");
const email = ref<string>("");
userId.value = user ? user.value.data.id : "";

watch(user, (newUser: any) => {
    userId.value = newUser.data.id;
    username.value = newUser.data.username;
    email.value = newUser.data.email;
});

const selectedDates = ref({
    startDateRange: null,
    endDateRange: null,
});

function handleDateChange(dates: { startDateRange: Date; endDateRange: Date }) {
    selectedDates.value = dates;

    store.commit("setDateRange", selectedDates);
    console.log("Date range changed:", dates);
}
const formatValue = (val) => val.toString().padStart(2, "0");

const currentMonthStart = new Date(
    new Date().getFullYear(),
    new Date().getMonth(),
    1
);
const currentMonthEnd = new Date(
    new Date().getFullYear(),
    new Date().getMonth() + 1,
    0
);
const currentMonthStartString =
    currentMonthStart.getFullYear() +
    "-" +
    formatValue(currentMonthStart.getMonth() + 1) +
    "-" +
    formatValue(currentMonthStart.getDate()) +
    " 00:00:00";

const currentMonthEndString =
    currentMonthEnd.getFullYear() +
    "-" +
    formatValue(currentMonthEnd.getMonth() + 1) +
    "-" +
    formatValue(currentMonthEnd.getDate()) +
    " 23:59:59";

const workingTimes = ref([]);
const getWorkingTimes = async () => {
    if (!userId.value || !currentMonthStartString || !currentMonthEndString) {
        console.error("Missing required parameters for request");
        return;
    }
    try {
        const response = await workingtimeService.getAllWorkingTimes(
            userId.value,
            currentMonthStartString,
            currentMonthEndString
        );
        workingTimes.value = response.data;
    } catch (error) {
        console.error("Error fetching working times:", error);
    }
};
getWorkingTimes();

const calculateDuration = (start: Date, end: Date) => {
    const startTime = new Date(start);
    const endTime = new Date(end);
    return (
        (endTime.getHours() - startTime.getHours()) * 60 +
        (endTime.getMinutes() - startTime.getMinutes())
    );
};

const calculateTotalHours = () => {
    let total = 0;
    workingTimes.value.forEach((work) => {
        const duration = calculateDuration(
            new Date(work.start),
            new Date(work.end)
        );
        total += duration;
    });
    return total;
};

let totalHours = ref(0);
watch(workingTimes, () => {
    totalHours.value = calculateTotalHours();
});

import ClockBtn from "@/components/ClockBtn.vue";
import ClockDaily from "@/components/ClockDaily.vue";
</script>

<template>
    <div class="hidden flex-col md:flex">
        <div class="border-b">
            <div class="flex h-16 items-center px-4">
                <MainNav class="mx-6" />
                <div class="ml-auto flex items-center space-x-4">
                    <Search />
                    <UserNav />
                </div>
            </div>
        </div>
        <div class="flex-1 space-y-4 p-8 pt-6">
            <div class="flex items-center justify-between space-y-2">
                <h2 class="text-3xl font-bold tracking-tight">Dashboard</h2>
                <div class="flex items-center space-x-2">
                    <DateRangePicker @date-change="handleDateChange" />
                    <ClockBtn />
                </div>
            </div>
            <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                <Card>
                    <CardHeader
                        class="flex flex-row items-center justify-between space-y-0 pb-2"
                    >
                        <CardTitle class="text-sm font-medium">
                            Total Hour this month
                        </CardTitle>
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            class="h-4 w-4 text-muted-foreground"
                        >
                            <path
                                d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"
                            />
                        </svg>
                    </CardHeader>
                    <CardContent>
                        <div class="text-2xl font-bold">
                            {{ Math.floor(totalHours / 60) }} hours
                            {{ totalHours % 60 }} minutes
                        </div>
                        <p class="text-xs text-muted-foreground">
                            +20.1% from last month
                        </p>
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader
                        class="flex flex-row items-center justify-between space-y-0 pb-2"
                    >
                        <CardTitle class="text-sm font-medium">
                            Subscriptions
                        </CardTitle>
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            class="h-4 w-4 text-muted-foreground"
                        >
                            <path
                                d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"
                            />
                            <circle cx="9" cy="7" r="4" />
                            <path
                                d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"
                            />
                        </svg>
                    </CardHeader>
                    <CardContent>
                        <div class="text-2xl font-bold">+2350</div>
                        <p class="text-xs text-muted-foreground">
                            +180.1% from last month
                        </p>
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader
                        class="flex flex-row items-center justify-between space-y-0 pb-2"
                    >
                        <CardTitle class="text-sm font-medium">
                            Time Work
                        </CardTitle>
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            class="h-4 w-4 text-muted-foreground"
                        >
                            <rect width="20" height="14" x="2" y="5" rx="2" />
                            <path d="M2 10h20" />
                        </svg>
                    </CardHeader>
                    <CardContent>
                        <ClockDaily />
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader
                        class="flex flex-row items-center justify-between space-y-0 pb-2"
                    >
                        <CardTitle class="text-sm font-medium">
                            Active Now
                        </CardTitle>
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            class="h-4 w-4 text-muted-foreground"
                        >
                            <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
                        </svg>
                    </CardHeader>
                    <CardContent>
                        <div class="text-2xl font-bold">+573</div>
                        <p class="text-xs text-muted-foreground">
                            +201 since last hour
                        </p>
                    </CardContent>
                </Card>
            </div>
            <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
                <Card class="col-span-4">
                    <CardHeader>
                        <CardTitle>Overview</CardTitle>
                    </CardHeader>
                    <CardContent class="pl-2">
                        <OverviewMonth />
                    </CardContent>
                </Card>
                <Card class="col-span-3">
                    <RecentSales />
                </Card>
            </div>
        </div>
    </div>
</template>
