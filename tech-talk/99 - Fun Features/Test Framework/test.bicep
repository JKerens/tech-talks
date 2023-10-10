// Test the main file
test testMain 'main.bicep' = {
  params: {
    isBreaking: true
    version: 1
  }
}
