/*
   This program makes 10x10 mazes and prints them on the screen.  No
   promise of portability is made, but it does seem to work on NS GNX
   C.

   Public Domain by Jonathan Guthrie.
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define UP  1
#define DN  2
#define LT  4
#define RT  8
#define SIZ 23
#define SIZ2 23

int  addelem(int, int [SIZ2][SIZ], int *, int, int);
void openwall(int [SIZ2][SIZ], int, int);
void writemaze(int [SIZ2][SIZ]);

int main( int argc, char *argv[] )
{
      int i, j, base;
      int search[150], array[SIZ2][SIZ];
      
      for(i=1 ; i<SIZ2-1 ; ++i)
      {
            array[i][0] = -1;
            array[i][SIZ-1] = -1;
            array[0][i] = -1;
            array[SIZ2-1][i] = -1;
            for(j=1 ; j<SIZ-1 ; ++j)
                  array[i][j] = 0;
      }

      srand((int)time(NULL));
      i = rand() % 10 + 1;
      j = rand() % 10 + 1;
      base = addelem(0, array, search, i, j);
      array[i][j] = RT + RT;      /* Not a valid value */
      while(0 < base)
      {
            i = rand() % base;
            j = search[i];
            search[i] = search[--base];
            i = j % 100;
            j /= 100;
            openwall(array, i, j);
            base = addelem(base, array, search, i, j);
      }
      
      writemaze(array);
      
      return 0;
}


int addelem(int base, int maze[SIZ2][SIZ], int *search, int row, int col)
{
      if(0 == maze[row-1][col])
      {
            search[base++] = row + col * 100 - 1;
            maze[row-1][col] = -DN;
      }
      else if(0 > maze[row-1][col])
            maze[row-1][col] -= DN;

      if(0 == maze[row+1][col])
      {
            search[base++] = row + col * 100 + 1;
            maze[row+1][col] = -UP;
      }
      else if(0 > maze[row+1][col])
            maze[row+1][col] -= UP;

      if(0 == maze[row][col-1])
      {
            search[base++] = row + col * 100 - 100;
            maze[row][col-1] = -RT;
      }
      else if(0 > maze[row][col-1])
            maze[row][col-1] -= RT;

      if(0 == maze[row][col+1])
      {
            search[base++] = row + col * 100 + 100;
            maze[row][col+1] = -LT;
      }
      else if(0 > maze[row][col+1])
            maze[row][col+1] -= LT;

      return base;
}


void openwall(int maze[SIZ2][SIZ], int row, int col)
{
      int directions, max, direction, temprow, tempcol, temp, back;

      directions = -maze[row][col];

      max = 0;
      if(directions & UP)
      {
            temp = rand();
            if(temp > max)
            {
                  max = temp;
                  direction = UP;
                  back = DN;
                  temprow = row - 1;
                  tempcol = col;
            }           
      }

      if(directions & DN)
      {
            temp = rand();
            if(temp > max)
            {
                  max = temp;
                  direction = DN;
                  back = UP;
                  temprow = row + 1;
                  tempcol = col;
            }
      }

      if(directions & LT)
      {
            temp = rand();
            if(temp > max)
            {
                  max = temp;
                  direction = LT;
                  back = RT;
                  temprow = row;
                  tempcol = col - 1;
            }
      }

      if(directions & RT)
      {
            temp = rand();
            if(temp > max)
            {
                  max = temp;
                  direction = RT;
                  back = LT;
                  temprow = row;
                  tempcol = col + 1;
            }
      }
    
      maze[row][col] = direction;
      maze[temprow][tempcol] += back;
}

void writemaze(int maze[SIZ2][SIZ])
{
      int i, j;
      FILE *fp;

//      puts("*********************");
            
//      for(i=1 ; i<SIZ-1 ; ++i)
//      {
//            putchar('*');
//            for(j=1 ; j<SIZ-1 ; ++j)
//            {
//                  putchar(' ');
//                  if(maze[i][j] & RT)
//                        putchar(' ');
//                  else  putchar('*');
//            }
//            putchar('\n');
//            for(j=1 ; j<SIZ-1 ; ++j)
//            {
//                  putchar('*');
//                  if(maze[i][j] & DN)
//                        putchar(' ');
//                  else  putchar('*');
//            }
//            puts("*");
//      }

      char * ruta;
      const char * var = getenv("PATH_XU");
      ruta = (char *)calloc(strlen(var)+40,1);
      strcpy(ruta, var);
      strcat(ruta, "/source/dataLabRat/laberinto.txt");


      printf("RUTA = %s\n",ruta);
      fp=fopen(ruta,"w");
      for(i=1 ; i<SIZ2-1 ; ++i)
      {
            for(j=1 ; j<SIZ-1 ; ++j)
            {
                 if(j<SIZ-2)
                    fprintf(fp,"%d,",maze[i][j]);
                 else
                    fprintf(fp,"%d",maze[i][j]);
            }
            fprintf(fp,"\n");
      }
      fclose(fp);
      free(ruta);
}
