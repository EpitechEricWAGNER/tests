<script setup lang="ts">
import { ref, computed, h, watch } from 'vue';
import { useStore } from 'vuex';
import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from '@/components/ui/avatar'

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'

import { workingtimeService } from '@/services/workingtimeService';
const store = useStore();
const user = computed(() => store.getters.user);

const userId = ref<string>('');
const username = ref<string>('');
const email = ref<string>('');

watch(user, (newUser: any) => {
  userId.value = newUser.data.id;
  username.value = newUser.data.username;
  email.value = newUser.data.email;
})

// récupérer les données du composant DateRangePicker
const dateRange = computed(() => store.getters.dateRange);

const startDateRange = ref<string>("");
const endDateRange = ref<string>("");

watch(dateRange, (newDate: any) => {
  console.log(JSON.stringify(newDate));
  startDateRange.value = newDate.startDateRange + " 00:00:00";
  endDateRange.value = newDate.endDateRange + " 23:59:59";
})

const workingTimes = ref([]);
const getWorkingTimes = async () => {
  console.log(userId, startDateRange, endDateRange)
  if (!userId.value || !startDateRange.value || !endDateRange.value) {
    console.error("Missing required parameters for request");
    return;
  }
  try {
    const response = await workingtimeService.getAllWorkingTimes(userId.value, startDateRange.value, endDateRange.value);
    workingTimes.value = response;
    console.log(workingTimes.value);
  } catch (error) {
    console.error("Error fetching working times:", error);
  }
};

// if user != null && dateRange.value
watch(
  () => [user.value, dateRange.value],
  () => {
    if (user.value && dateRange.value) {
      getWorkingTimes();
    }
  }
);

</script>

<template>
  <CardHeader>
    <CardTitle>Working Times</CardTitle>
    <CardDescription>
      You made 265 sales this month.
    </CardDescription>
  </CardHeader>
  <CardContent>
    <div class="space-y-8">
      <div class="flex items-center">
        <Avatar class="h-9 w-9">
          <AvatarImage src="/avatars/01.png" alt="Avatar" />
          <AvatarFallback>OM</AvatarFallback>
        </Avatar>
        <div class="ml-4 space-y-1">
          <p class="text-sm font-medium leading-none">
            Olivia Martin
          </p>
          <p class="text-sm text-muted-foreground">
            olivia.martin@email.com
          </p>
        </div>
        <div class="ml-auto font-medium">
          +$1,999.00
        </div>
      </div>
      <div class="flex items-center">
        <Avatar class="flex h-9 w-9 items-center justify-center space-y-0 border">
          <AvatarImage src="/avatars/02.png" alt="Avatar" />
          <AvatarFallback>JL</AvatarFallback>
        </Avatar>
        <div class="ml-4 space-y-1">
          <p class="text-sm font-medium leading-none">
            Jackson Lee
          </p>
          <p class="text-sm text-muted-foreground">
            jackson.lee@email.com
          </p>
        </div>
        <div class="ml-auto font-medium">
          +$39.00
        </div>
      </div>
      <div class="flex items-center">
        <Avatar class="h-9 w-9">
          <AvatarImage src="/avatars/03.png" alt="Avatar" />
          <AvatarFallback>IN</AvatarFallback>
        </Avatar>
        <div class="ml-4 space-y-1">
          <p class="text-sm font-medium leading-none">
            Isabella Nguyen
          </p>
          <p class="text-sm text-muted-foreground">
            isabella.nguyen@email.com
          </p>
        </div>
        <div class="ml-auto font-medium">
          +$299.00
        </div>
      </div>
      <div class="flex items-center">
        <Avatar class="h-9 w-9">
          <AvatarImage src="/avatars/04.png" alt="Avatar" />
          <AvatarFallback>WK</AvatarFallback>
        </Avatar>
        <div class="ml-4 space-y-1">
          <p class="text-sm font-medium leading-none">
            William Kim
          </p>
          <p class="text-sm text-muted-foreground">
            will@email.com
          </p>
        </div>
        <div class="ml-auto font-medium">
          +$99.00
        </div>
      </div>
      <div class="flex items-center">
        <Avatar class="h-9 w-9">
          <AvatarImage src="/avatars/05.png" alt="Avatar" />
          <AvatarFallback>SD</AvatarFallback>
        </Avatar>
        <div class="ml-4 space-y-1">
          <p class="text-sm font-medium leading-none">
            Sofia Davis
          </p>
          <p class="text-sm text-muted-foreground">
            sofia.davis@email.com
          </p>
        </div>
        <div class="ml-auto font-medium">
          +$39.00
        </div>
      </div>
    </div>
  </CardContent>
</template>
