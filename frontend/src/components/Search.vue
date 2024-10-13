<script setup lang="ts">
import { ref } from 'vue';
import { Input } from '@/components/ui/input';
import UserServices from "@/services/UserServices";

const searchValue = ref('');

const search = async () => {
  const inputValue = searchValue.value;
  const isEmail = inputValue.includes('@');
  await UserServices.getUser(
    isEmail ? undefined : inputValue,
    isEmail ? inputValue : undefined  
  );
};
</script>

<template>
  <div>
    <Input 
      type="search" 
      placeholder="Search by username or email..." 
      class="md:w-[100px] lg:w-[300px]" 
      v-model="searchValue" 
      @keyup.enter="search" 
    />
  </div>
</template>
