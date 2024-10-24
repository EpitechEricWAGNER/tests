<script setup lang="ts">
import { ref, watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import * as z from 'zod';
import userService from '@/services/userService';
import { workingtimeService } from '@/services/workingtimeService';
import DateRangePicker from "@/components/DateRangePicker.vue";
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Separator } from '@/components/ui/separator';
import { Select, SelectContent, SelectGroup, SelectItem, SelectLabel, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Button } from '@/components/ui/button';

const schema = z.object({
  userId: z.string().nonempty("Please select an employee"),
});

const { handleSubmit } = useForm({
  validationSchema: toTypedSchema(schema),
});

interface UserResponse {
  id: string;
  username: string;
  email: string;
}

const users = ref<UserResponse[]>([]); // Use UserResponse type here
const userId = ref<string>('');
const dateRange = ref({ startDateRange: '', endDateRange: '' });
const startDateRange = ref<string>('');
const endDateRange = ref<string>('');

function handleDateChange(dates: { startDateRange: string, endDateRange: string }) {
  dateRange.value = dates;
}

const today = new Date();
const todayString = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
startDateRange.value = todayString + " 00:00:00";
endDateRange.value = todayString + " 23:59:59";

const getUsers = async () => {
  const response = await userService.getAllUsers();
  users.value = response.map(user => ({
    ...user,
    id: String(user.id),
  }));
};
getUsers();

watch(dateRange, (newDate: any) => {
  startDateRange.value = newDate.startDateRange + " 00:00:00";
  endDateRange.value = newDate.endDateRange + " 23:59:59";
});

const padZero = (num: number) => num.toString().padStart(2, '0');

const formatDateTimeLocal = (date: Date): string => {
  const day = date.getDate();
  const month = date.getMonth() + 1;
  const year = date.getFullYear();
  const hour = date.getHours();
  const minute = date.getMinutes();

  const dayString = padZero(day);
  const monthString = padZero(month);
  const hourString = padZero(hour);
  const minuteString = padZero(minute);

  return `${year}-${monthString}-${dayString}T${hourString}:${minuteString}`;
};

interface WorkingTime {
  id: number;
  start: string | Date;
  end: string | Date;
  date?: string;
  hours?: string;
  startLocal?: string;
  endLocal?: string;
}

interface WorkingTimeResponse {
  id: string;
  start: string | Date;
  end: string | Date;
}

const workingTimes = ref<WorkingTime[]>([]);

const getWorkingTimes = async () => {
  if (!userId.value || !startDateRange.value || !endDateRange.value) {
    console.error("Missing required parameters for request");
    return;
  }
  try {
    const response = await workingtimeService.getAllWorkingTimes(userId.value, startDateRange.value, endDateRange.value);
    
    workingTimes.value = response.map((item: WorkingTimeResponse) => ({
      id: Number(item.id),
      start: new Date(item.start),
      end: new Date(item.end),
    }));

    workingTimes.value.sort((a, b) => {
      const dateA = new Date(a.start).getTime();
      const dateB = new Date(b.start).getTime();
      return dateA - dateB;
    });

    workingTimes.value.forEach((workingTime) => {
      workingTime.date = (new Date(workingTime.start)).toLocaleDateString("fr-FR", {
        day: "numeric",
        month: "long",
        year: "numeric",
      });
      workingTime.hours = (new Date(workingTime.start)).toLocaleTimeString(undefined, {
        hour: "2-digit",
        minute: "2-digit",
      }) + " to " + (new Date(workingTime.end)).toLocaleTimeString(undefined, {
        hour: "2-digit",
        minute: "2-digit",
      });

      workingTime.startLocal = formatDateTimeLocal(workingTime.start as Date);
      workingTime.endLocal = formatDateTimeLocal(workingTime.end as Date);
    });
  } catch (error) {
    console.error("Error fetching working times:", error);
  }
};

const updateWorkingTime = async (workingTime: WorkingTime) => {
  try {
    const updatedData = {
      start: workingTime.startLocal ?? '',  // Ensure start is a string
      end: workingTime.endLocal ?? '',      // Ensure end is a string
      user: userId.value,                   // Include the user ID here
    };
    
    if (!updatedData.start || !updatedData.end) {
      console.error("Start or End time is missing");
      return;
    }

    await workingtimeService.updateWorkingTime(String(workingTime.id), updatedData);
    getWorkingTimes();
  } catch (error) {
    console.error("Error updating working time:", error);
  }
};

const deleteWorkingTime = async (id: number) => {
  try {
    await workingtimeService.deleteWorkingTime(String(id));
    getWorkingTimes();
  } catch (error) {
    console.error("Error deleting working time:", error);
  }
};

const submitForm = handleSubmit(() => {
  if (userId.value && startDateRange.value && endDateRange.value) {
    getWorkingTimes();
  } else {
    console.error("Form is incomplete");
  }
});

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';

import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';

import { Input } from '@/components/ui/input';

</script>

<template>
  <div class="space-y-8">
    <form @submit.prevent="submitForm" class="space-y-8">
      <div class="flex gap-5 items-end">
        <FormField name="userId" v-slot="{ field, errors }">
          <FormItem>
            <FormLabel>Select an Employee</FormLabel>
            <FormControl>
              <Select v-model="userId" v-bind="field">
                <SelectTrigger>
                  <SelectValue placeholder="Select an employee" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup>
                    <SelectLabel>Employees</SelectLabel>
                    <template v-for="user in users" :key="user.id">
                      <SelectItem :value="String(user.id)">{{ user.username }}</SelectItem>
                    </template>
                  </SelectGroup>
                </SelectContent>
              </Select>
            </FormControl>
            <FormMessage>{{ errors }}</FormMessage>
          </FormItem>
        </FormField>

        <DateRangePicker v-model="dateRange" @date-change="handleDateChange" />
      </div>
      <div class="flex gap-2 justify-start">
        <Button type="submit">Submit</Button>
      </div>
    </form>

    <Separator />

    <div v-if="workingTimes.length > 0">
      <Table>
        <TableCaption>The list of the employee Working Times.</TableCaption>
        <TableHeader>
          <TableRow>
            <TableHead>Date</TableHead>
            <TableHead>Hours</TableHead>
            <TableHead class="text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="workingTime in workingTimes" :key="workingTime.id">
            <TableCell>{{ workingTime.date }}</TableCell>
            <TableCell>{{ workingTime.hours }}</TableCell>
            <TableCell class="text-right">
              <div class="flex gap-2 items-center justify-end">
                <Dialog>
                  <DialogTrigger as-child>
                    <Button variant="outline">Edit</Button>
                  </DialogTrigger>
                  <DialogContent class="sm:max-w-[425px] grid-rows-[auto_minmax(0,1fr)_auto] p-0 max-h-[90dvh]">
                    <DialogHeader class="p-6 pb-0">
                      <DialogTitle>Edit Working Time</DialogTitle>
                      <DialogDescription>
                        Update the working time for the employee.
                      </DialogDescription>
                    </DialogHeader>
                    
                    <form @submit.prevent="updateWorkingTime(workingTime)" class="grid gap-4 py-4 overflow-y-auto px-6">
                      <FormField name="start" v-slot="{ field, errors }">
                        <FormItem>
                          <FormLabel>Start Time</FormLabel>
                          <FormControl>
                            <Input
                              v-model="workingTime.startLocal"
                              type="datetime-local"
                              class="input"
                              v-bind="field"
                            />
                          </FormControl>
                          <FormMessage>{{ errors }}</FormMessage>
                        </FormItem>
                      </FormField>
                      
                      <FormField name="end" v-slot="{ field, errors }">
                        <FormItem>
                          <FormLabel>End Time</FormLabel>
                          <FormControl>
                            <Input
                              v-model="workingTime.endLocal"
                              type="datetime-local"
                              class="input"
                              v-bind="field"
                            />
                          </FormControl>
                          <FormMessage>{{ errors }}</FormMessage>
                        </FormItem>
                      </FormField>
                      <DialogFooter>
                        <Button type="submit">Update</Button>
                      </DialogFooter>
                    </form>
                  </DialogContent>
                </Dialog>

                <Button variant="destructive" @click="deleteWorkingTime(workingTime.id)">Delete</Button>
              </div>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </div>
  </div>
</template>
