<script setup lang="ts">
import { computed, ref } from 'vue';
import { useStore } from 'vuex';
import { Input } from '@/components/ui/input'
import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form'
import { Separator } from '@/components/ui/separator'
import {
  Select,
} from '@/components/ui/select'
import { Button } from '@/components/ui/button'

const store = useStore();
const user = computed(() => store.getters.user);

const username = ref<string>('');
const email = ref<string>('');

</script>

<template>
  <div>
    <h3 class="text-lg font-medium">
      Profile
    </h3>
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
          <Input type="text" :placeholder="user.data.username" v-bind="componentField" v-model="username" />
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
            <Input type="email" :placeholder="user.data.email" v-bind="componentField" v-model="email" />
          </FormControl>
        </Select>
        <FormDescription>
          You can manage verified email addresses in your email settings.
        </FormDescription>
        <FormMessage />
      </FormItem>
    </FormField>

    <div class="flex gap-2 justify-start">
      <Button type="submit">
        Update profile
      </Button>

      <Button type="button" variant="destructive">
        Delete
      </Button>
    </div>
  </form>
</template>
