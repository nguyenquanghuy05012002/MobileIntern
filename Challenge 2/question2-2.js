function findMissingNumber(arr) {
  const n = arr.length + 1;
  const expectedSum = (n * (n + 1)) / 2;
  const actualSum = arr.reduce((sum, num) => sum + num, 0);

  return expectedSum - actualSum;
}

const inputArray = [3, 7, 1, 2, 6, 4];
const missingNumber = findMissingNumber(inputArray);
console.log("Missing Number:", missingNumber);
