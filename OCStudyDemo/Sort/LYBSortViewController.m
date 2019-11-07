//
//  LYBSortViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/7/27.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBSortViewController.h"

@interface LYBSortViewController ()

@end

@implementation LYBSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int A[] = {6,5,3,1,8,7,2,4};
    int n = sizeof(A)/sizeof(int);
    
//    BubbleSort(A, n);
//    Print(A, n);
    
//    SelectionSort(A, n);
//    Print(A, n);
    
//    InsertSort(A, n);
//    Print(A, n);

    QuickSort(A, 0, n - 1);
    Print(A, n);

}

void Print(int A[], int n){
    for (int i=0; i<n; i++) {
        printf("%d ",A[i]);
    }
    printf("\n");
}


void Swap(int A[], int i, int j){
    int temp = A[i];
    A[i] = A[j];
    A[j] = temp;
}

//冒泡排序
void BubbleSort(int A[], int n){
    for (int j = 0; j<n-1; j++) {
        for (int i = 0; i<n-1-j; i++) {
            if (A[i]>A[i+1]) {
                Swap(A,i,i+1);
            }
        }
    }
}

//选择排序
void SelectionSort(int A[], int n){
    for (int i = 0; i<n-1; i++) {
        int min = i;
        for (int j = i+1; j<n; j++) {
            if (A[min]>A[j]) {
                min = j;
            }
        }
        if (min!=i) {
            Swap(A, i, min);
        }
    }
}

//插入排序
void InsertSort(int A[], int n){
    for (int i = 1; i<n; i++) {
        int get = A[i];
        int j = i - 1;
        while (j>=0&&A[j]>get) {
            A[j+1] = A[j];
            j--;
        }
        A[j+1] = get;
    }
}

int partition(int A[], int left, int right){
    int pivot = A[right];
    int tail = left-1;
    for (int i=left; i<right; i++) {
        if (A[i]<pivot) {
            if (tail+1!=i) {
                Swap(A, i, ++tail);
            }
        }
    }
    Swap(A, tail+1, right);
    return tail+1;
}

void QuickSort(int A[], int left ,int right){
    if (left>=right) {
        return;
    }
    int pivot_index = partition(A, left, right);
    QuickSort(A, left, pivot_index-1);
    QuickSort(A, pivot_index+1, right);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
