<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { useStore } from 'vuex';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { ScrollArea } from '@/components/ui/scroll-area';
import { workingtimeService } from '@/services/workingtimeService';

const store = useStore();
const user = computed(() => store.getters.user);

const userId = ref<string>('');
const username = ref<string>('');
const email = ref<string>('');
const loading = ref<boolean>(false);

userId.value = user ? user.value.data.id : '';

watch(user, (newUser: any) => {
  userId.value = newUser.data.id;
  username.value = newUser.data.username;
  email.value = newUser.data.email;
});

const dateRange = computed(() => store.getters.dateRange);
const startDateRange = ref<string>('');
const endDateRange = ref<string>('');

startDateRange.value = (dateRange.value.startDateRange != null ? dateRange.value.startDateRange + " 00:00:00" : "");
endDateRange.value = (dateRange.value.endDateRange != null ? dateRange.value.endDateRange + " 23:59:59" : "");

watch(dateRange, (newDate: any) => {
  startDateRange.value = newDate.startDateRange + " 00:00:00";
  endDateRange.value = newDate.endDateRange + " 23:59:59";
});

interface WorkingTimeResponse {
    start: string; // or Date if necessary
    end: string; // or Date if necessary
}

const workingTimes = ref<WorkingTimeResponse[]>([]);

const calculateDuration = (start: Date, end: Date) => {
  const startTime = new Date(start);
  const endTime = new Date(end);
  return (endTime.getHours() - startTime.getHours()) * 60 +
         (endTime.getMinutes() - startTime.getMinutes());
};

const workingTimesRange = computed(() => {
  const timesMap: Record<string, any> = {};
  workingTimes.value.forEach((work: WorkingTimeResponse) => {
    const startingDate = new Date(work.start).toLocaleString('default', {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    });
  
    const endingDate = new Date(work.end).toLocaleString('default', {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    });

    const duration = calculateDuration(new Date(work.start), new Date(work.end));
    const key = `${startingDate}-${endingDate}`;

    if (timesMap[key]) {
      timesMap[key].duration += duration;
    } else {
      timesMap[key] = {
        startingDate,
        endingDate,
        duration,
      };
    }
  });

  return Object.values(timesMap);
});

const totalDuration = computed(() => {
  let totalMinutes = 0;
  workingTimesRange.value.forEach((work: any) => {
    totalMinutes += work.duration;
  });
  return totalMinutes;
});

const totalHours = computed(() => Math.floor(totalDuration.value / 60));
const totalMinutes = computed(() => totalDuration.value % 60);

const getWorkingTimes = async () => {
  if (!userId.value || !startDateRange.value || !endDateRange.value) {
    console.error("Missing required parameters for request");
    return;
  }
  loading.value = true; // Set loading to true when starting the request
  try {
    const response = await workingtimeService.getAllWorkingTimes(userId.value, startDateRange.value, endDateRange.value) as WorkingTimeResponse[];
    workingTimes.value = response;
  } catch (error) {
    console.error("Error fetching working times:", error);
  } finally {
    loading.value = false; // Set loading to false once data is loaded
  }
};

getWorkingTimes();

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
  <div>
    <CardHeader>
      <CardTitle>Working Times</CardTitle>
      <CardDescription>
        For the selected period, you have to work {{ totalHours }} hours and {{ totalMinutes }} minutes.
      </CardDescription>
    </CardHeader>
    <CardContent>
      <div>
        <div v-if="loading" class="flex justify-center items-center">
          <div class="loader"></div>
        </div>
        <div v-else>
          <div v-if="workingTimesRange.length === 0" class="text-center text-sm text-muted-foreground">
            No data found.
          </div>
          <ScrollArea class="h-[400px]" v-else>
            <div class="space-y-8">
              <div class="flex items-center" v-for="work in workingTimesRange" :key="work.startingDate">
                <Avatar class="h-9 w-9">
                  <AvatarImage src="/avatars/01.png" alt="Avatar" />
                  <AvatarFallback>OM</AvatarFallback>
                </Avatar>
                <div class="ml-4 space-y-1">
                  <p class="text-sm font-medium leading-none">
                    Date : {{ work.startingDate }}
                  </p>
                </div>
                <div class="ml-auto font-medium">
                  {{ Math.floor(work.duration / 60) }} hours {{ work.duration % 60 }} minutes
                </div>
              </div>
            </div>
          </ScrollArea>
        </div>
      </div>
    </CardContent>
  </div>
</template>

<style scoped>
.loader {
  border: 8px solid #f3f3f3;
  border-radius: 50%;
  border-top: 8px solid #3498db;
  width: 40px;
  height: 40px;
  animation: spin 2s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>