<script setup lang="ts">
import { ref, watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import * as z from 'zod';
import userService from '@/services/userService';
import { workingtimeService } from '@/services/workingtimeService';
import DateRangePicker from "@/components/DateRangePicker.vue";
import { useStore } from 'vuex';
import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Separator } from '@/components/ui/separator';
import { Select, SelectContent, SelectGroup, SelectItem, SelectLabel, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Button } from '@/components/ui/button';

const schema = z.object({
  userId: z.string().nonempty("Please select an employee"),
});

const { handleSubmit, errors, resetForm, values } = useForm({
  validationSchema: toTypedSchema(schema),
});

const users = ref([]);
const userId = ref('');
const dateRange = ref({ startDateRange: '', endDateRange: '' });
const startDateRange = ref<string>("");
const endDateRange = ref<string>("");
function handleDateChange(dates: { startDateRange: Date, endDateRange: Date }) {
  dateRange.value = dates;
}
const today = new Date();
const todayString = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
startDateRange.value = todayString + " 00:00:00";
endDateRange.value = todayString + " 23:59:59";

const getUsers = async () => {
  const response = await userService.getAllUsers();
  users.value = response;
};
getUsers();

watch(dateRange, (newDate: any) => {
  startDateRange.value = newDate.startDateRange + " 00:00:00";
  endDateRange.value = newDate.endDateRange + " 23:59:59";
});

const workingTimes = ref([]);

const getWorkingTimes = async () => {
  if (!userId.value || !startDateRange.value || !endDateRange.value) {
    console.error("Missing required parameters for request");
    return;
  }
  try {
    const response = await workingtimeService.getAllWorkingTimes(userId.value, startDateRange.value, endDateRange.value);
    workingTimes.value = response.data;
    workingTimes.value.forEach((workingTime) => {
      workingTime.start = new Date(workingTime.start);
      workingTime.end = new Date(workingTime.end);
      workingTime.date = workingTime.start.toLocaleDateString("fr-FR", {
        day: "numeric",
        month: "long",
        year: "numeric",
      });
      workingTime.hours = workingTime.start.toLocaleTimeString(undefined, {
        hour: "2-digit",
        minute: "2-digit",
      }) + " to " + workingTime.end.toLocaleTimeString(undefined, {
        hour: "2-digit",
        minute: "2-digit",
      });
    });
  } catch (error) {
    console.error("Error fetching working times:", error);
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
} from '@/components/ui/dialog'

import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'

import { Input } from '@/components/ui/input'


const updateWorkingTime = async (workingTime: any) => {
  try {
    const updatedData = {
      start: workingTime.start,
      end: workingTime.end,
    };
    console.log("Updating working time:", workingTime);
    await workingtimeService.updateWorkingTime(workingTime.id, updatedData);
    console.log("Working time updated successfully");
    // Optionally, refetch working times or update locally
    getWorkingTimes();
  } catch (error) {
    console.error("Error updating working time:", error);
  }
};


</script>

<template>
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
          <FormMessage>{{ errors.userId }}</FormMessage>
        </FormItem>
      </FormField>

      <DateRangePicker v-model="dateRange" @date-change="handleDateChange"/>
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
          <TableHead class="text-right">
            Actions
          </TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="workingTime in workingTimes" :key="workingTime.id">
          <TableCell>{{ workingTime.date }}</TableCell>
          <TableCell>{{ workingTime.hours }}</TableCell>
          <TableCell class="text-right">
            <Dialog>
              <DialogTrigger as-child>
                <Button variant="outline">
                  Edit
                </Button>
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
                          v-model="workingTime.start"
                          type="datetime-local"
                          class="input"
                          v-bind="field"
                        />
                      </FormControl>
                      <FormMessage>{{ errors.start }}</FormMessage>
                    </FormItem>
                  </FormField>
                  
                  <FormField name="end" v-slot="{ field, errors }">
                    <FormItem>
                      <FormLabel>End Time</FormLabel>
                      <FormControl>
                        <Input
                          v-model="workingTime.end"
                          type="datetime-local"
                          class="input"
                          v-bind="field"
                        />
                      </FormControl>
                      <FormMessage>{{ errors.end }}</FormMessage>
                    </FormItem>
                  </FormField>
                  <DialogFooter class="p-6 pt-0">
                    <Button type="submit">Save changes</Button>
                  </DialogFooter>
                </form>
              </DialogContent>
            </Dialog>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </div>
</template>
