#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
//mikhaylov a
int a = 0;
void *mythreadfirst(void *dummy)
{
    pthread_t mythid;
    mythid = pthread_self();
    a = a+10;
    printf("First child thread (%d), calculation result(+10) = %d\n\n",(int)mythid, a);
    return NULL;
}

void *mythreadsecond(void *dummy)
{
    pthread_t mythid;
    mythid = pthread_self();
    a = a+1;
    printf("Second child thread (%d), calculation result(+1) = %d\n\n",(int)mythid, a);
    return NULL;
}

int main()
{
    pthread_t thid, second_thid, third_thid;
    
    int result;
    result = pthread_create( &thid, NULL, mythreadfirst, NULL);
    if(result != 0){
        printf ("Error on thread create, return value = %d\n", result);
        exit(-1);
    }
    result = pthread_create( &thid,NULL, mythreadsecond, NULL);
    if(result != 0){
        printf ("Error on thread create, return value = %d\n", result);
        exit(-1);
    }
    third_thid = pthread_self();
    a = a+100;
    printf("Parent thread (%d), calculation result(+100) = %d\n",(int)third_thid, a);
    
    pthread_join(thid, NULL);
    pthread_join(second_thid, NULL);
    
    return 0;
}
