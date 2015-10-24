'use strict';
/*
function invert(matrix) {
  var size = matrix.length;
  var result = [];
  var identity = [];
  var index = [];

  for (var i = 0; i < size; i++) {
    identity[i] = [];
    identity[i][i] = 1;
  }

  // Transform the matrix into an upper triangle
  gauss(matrix, index);

  // Update the identity matrix with the ratios stored
  for (int i = 0; i < size - 1; i++)
    for (int j = i + 1; j < size; j++)
      for (int k = 0; k < size; k++)
        identity[index[j]][k] -= matrix[index[j]][i] * identity[index[i]][k];

  // Backward substitution
  for (int i = 0; i < size; i++) {
    result[size - 1][i] = identity[index[size - 1]][i] / 
      matrix[index[size - 1]][size - 1];
    for (int j = size - 2; j >= 0; j--) {
      result[j][i] = identity[index[j]][i];
      for (int k = j + 1; k < size; k++) {
        result[j][i] -= matrix[index[j]][k] * result[k][i];
      }
      result[j][i] /= matrix[index[j]][j];
    }
  }
  return result;
}

// Gauss elimination. index[] stores pivots
public static void gauss(double matrix[][], int index[]) {
  int size = index.length;
  double c[] = new double[size];

  for (int i = 0; i < size; i++) index[i] = i;

  // Get ratios
  for (int i = 0; i < size; i++) {
    double min = 0, curr = 0;
    for (int j = 0; j < size; j++) {
      curr = Math.abs(matrix[i][j]);
      if (curr > min) min = curr;
    }
    c[i] = min;
  }

  // Search the pivoting element from each column
  int k = 0;
  for (int j = 0; j < size - 1; j++) {
    double pi, min = 0;
    for (int i = j; i < size; i++) {
      pi = Math.abs(matrix[index[i]][j]);
      pi /= c[index[i]];
      if (pi > min) {
        min = pi;
        k = i;
      }
    }

    // Pivot rows
    int tempIndex = index[j];
    index[j] = index[k];
    index[k] = tempIndex;
    for (int i = j + 1; i < size; i++) {
      double pj = matrix[index[i]][j] / matrix[index[j]][j];

      // Record pivoting ratios below the diagonal
      matrix[index[i]][j] = pj;

      // Modify other elements accordingly
      for (int l = j + 1; l < size; l++) {
        matrix[index[i]][l] -= pj * matrix[index[j]][l];
      }
    }
  }
}

public static void printMatrix(double[][] matrix) {
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[0].length; j++) {
      System.out.print(matrix[i][j] + ", ");
    }
    System.out.println();
  }
  System.out.println();
}

public static void benchmark(String title, double[][] matrix, boolean sequential) {
  double[][] inverse;

  System.out.println(title);
  //printMatrix(matrix);

  long start = System.currentTimeMillis();
  if (sequential) {
    inverse = invert(matrix);
  } else {
    System.out.println("Hello");
    inverse = invert(matrix);
  }
  long end = System.currentTimeMillis();
  double time = (end - start) / 1000.0;

  //printMatrix();
  System.out.printf("Time: %.2f%n", time);
}

public static void main(String... args) {
  double randomNum;
  double[][] matrix = new double[MAXN][MAXN];
  for (int i = 0; i < MAXN; i++) {
    for (int j = 0; j < MAXN; j++) {
      randomNum = 1.0 + (Math.random() * MAXN);
      matrix[i][j] = randomNum;
    }
  }
  benchmark("Sequential", matrix, true);
  benchmark("Concurrent", matrix, false);
}
}
function gcd(a, b) {
  var c;

  if (a > b) {
    c = a;
    a = b;
    b = c;
  }

  while (a !== 0) {
    c = a;
    a = b % a;
    b = c;
  }

  return b;
}

function isCoprime(a, b) {
  return gcd(a, b) === 1;

}

onmessage = function(event) {
  var start = event.data.start;
  var end = event.data.end;

  var sum = 0;

  for (var i = start; i < end; i++) {
    if (isCoprime(i, 666)) {
      sum += i;
    }
  }

  postMessage(sum);
}
*/
