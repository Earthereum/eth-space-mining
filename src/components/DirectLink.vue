<template>
  <meta http-equiv="refresh" :content="'0; url=' + this.url" />
</template>

<script>
export default {
  props: {
    'url': String
  }
}
</script>