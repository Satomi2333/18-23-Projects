#include<stdio.h>
#include<stdlib.h>	//system() exit()
#include<string.h>
#include<time.h>
#include "conio.h"	//getch()
#include "windows.h"	//Sleep()
#define DIR "data.dat"
#define PASSWORD "abc"		//只能是三位
#define PASSWORDAGAIN "abc"	//同上
#define N 40
#define SLEEP_TIME 50
#define FLASH_TIME 5

//2017.6.10更新 新增了读取文件和保存文件的加密过程
#define PASSCYPT 221

struct STU
{
	char id[13];
	char name[11];
	char gender;	//'M'为男性,'F'为女性
	unsigned short age; // 必须大于0
	char other[100];
}stu[N];
struct STU *p;
char flush;
char alnum[37]={"yzhdqewxkjr72u0ncm4o9ifa653spglv8b1t"};

void FirstPassword();	//进入系统时所需
int SecondPassword();	//进入修改界面时所需

//From Search_stu
int SearchId();       //输出值唯一 
int SearchName();     //
int SearchGender();   //
int SearchAge();      //


//From GUI_all
void guipassword();
void guipasswordagain();
void myputs(char a[]);
void guiaa_first(); //第一次加载aa界面时的 带跑马灯特效的界面
void guiaa(); //guiaa 第一个a是指 一级界面 的a界面    录入时要检查ID的重复性
void guiab();
void guiac();
void guiad();
void guiae();                                       //修改时要检查ID的重复性
void guiaf();
void guiag();
void guiba(); //guiba b是指 二级界面 的a界面
void guibb();
void guibc();
void guibd();
void guibe();
void guibfa();//二级界面 的f界面 的a界面
void guibfb();
void guibfc();
void guibfd();
void guibfaa();//三级界面 的f界面 的a界面 的a界面
void guibfbb();
void guibfcc();
void guibfdd();
void guibg(); //程序退出


//From FILE_abcdef
void Read_first();	 //程序运行时从文件读取数据 用rb打开
void Enter();		//aa 检查完整性 可以没有备注
int Onlyid(char a[13]);//检查id的重复性 有重复则返回0 无重复返回1
void Show();		//ab 至少显示一条记录  一条都没有的话返回"无数据"
int Save();		//ac 把stu写入data  用wb打开 当文件打开错误时返回0 和Read_first()不同 随意使用exit()可能会导致数据丢失
int Delete();		//ad 删除后数据要整体前移
void Change();		//ae 读取特定数据条

//以下是2018.6.10更新
void cypt(char a[]);			//加密或解密字符数组
void cypt_struct();			//调用cypt加密或解密结构体
void Read_first_and_encypt();		//读取文件并解密保存至结构体
int Save_and_cypt();		//保存文件并解密结构体并保存至文件
void MagicPutc_an(char a);
void MagicPuts_an(char a[]); //只输出alpha or number

void main()
{
	int a=0,b=0;
	system("title 班级档案管理系统               'w','s'键选择 Enter进入 Esc返回上一级                                      -Made By 201711107108");
	system("mode con cols=100 lines=27");
	system("color f0");
	Read_first_and_encypt();
	FirstPassword();
	system("cls");
	guiaa_first();
	while(1)
	{
		GUI_begin:
		switch(a%=7)
		{
			case 0:guiaa();break;
			case 1:guiab();break;
			case 2:guiac();break;
			case 3:guiad();break;
			case 4:guiae();break;
			case 5:guiaf();break;
			case 6:guiag();break;
		}
		switch(flush=getch())
		{
			case 119:  //w键
				if(a>0)a-=1;
				else if(a==0)a=6;
				break;
			case 115:  //s键
				a+=1;
				break;
			case 27:  //Esc
				a=6;
				break;
			case 13:  //Enter
			{
				switch(a%=7)
				{
					case 0:guiba();Enter();break;
					case 1:guibb();Show();break;
					case 2:guibc();Save_and_cypt();break;
					case 3:guibd();Delete();break;
					case 4:
					{
						if(SecondPassword()==0)			//此函数中调用了GUI 因此不需要guibe()
						{
							break;
						}
						guibe();
						Change();
						break;
					}
					case 5:
					{
						while(1)
						{
							switch(b%=4)
							{
								case 0:guibfa();break;
								case 1:guibfb();break;
								case 2:guibfc();break;
								case 3:guibfd();break;
							}
							fflush(stdin);
							switch(getch())
							{
								case 119:  //w键
									if(b>0)b-=1;
									else if(b==0)b=3;
									break;
								case 115:  //s键
									b+=1;
									break;
								case 27:  //Esc
									goto GUI_begin;
									break;
								case 13:  //Enter
								{
									switch(b%=4)
									{
										case 0:guibfaa();SearchId();break;
										case 1:guibfbb();SearchName();break;
										case 2:guibfcc();SearchGender();break;
										case 3:guibfdd();SearchAge();break;
									}
									break;
								}
							}
						}
					break;
					}
					case 6:guibg();break;
				}
			}
		}
	}
}


void FirstPassword()
{
	char ch1,ch2,ch3,pass[4]=PASSWORD;
	guipassword();
	ch1=getch();putchar('*');
	ch2=getch();putchar('*');
	ch3=getch();putchar('*');
	printf("\n");
	if((ch1==pass[0] && ch2==pass[1]) && ch3==pass[2])
	{
		printf("                                    ");
		MagicPuts_an("Right!welcome to this system..\n");
		Sleep(1000);
	}
	else
	{
		printf("                                       密码错误\n");
		Sleep(600);
		guibg();
	}
}

int SecondPassword()
{
	char ch1,ch2,ch3,pass[4]=PASSWORDAGAIN;
	guipasswordagain();
	ch1=getch();putchar('*');
	ch2=getch();putchar('*');
	ch3=getch();putchar('*');
	printf("\n");
	if((ch1==pass[0] && ch2==pass[1]) && ch3==pass[2])
	{
		printf("                                     密码正确,按任意键继续\n");
		getch();
		return 1;
	}
	else
	{
		printf("                                   密码错误,将返回上一级界面\n");
		Sleep(1000);
		return 0;
	}
}


int SearchId()
{
	char a[13];
	printf("请输入ID:");
	gets(a);
	for(p=stu;p<stu+N;p++)
	{
		if(strcmp(a,p->id)==0)
		{
			printf("\n学号：%s\n姓名：%s\n性别：%c\n年龄：%hd\n备注：%s\n\n",p->id,p->name,p->gender,p->age,p->other);
			printf("按任意键返回上一级");
			getch();
			return 1;
		}
	}
	printf("\n未查询到结果，按任意键返回上一级");
	getch();
	return 0;
}

int SearchName()
{
	int i=0;
	char a[11];
	printf("请输入名字:");
	gets(a);
	printf("\n学号\t\t姓名\t性别\t年龄\t备注\t\n");
	for(p=stu;p<stu+N;p++)
	{
		if(strcmp(a,p->name)==0)
		{
			printf("%s\t%s\t%c\t%hd\t%s\n",p->id,p->name,p->gender,p->age,p->other);
			i++;
		}
	}
	if(i>0)
	{
		printf("\n查询到%d个结果\n",i);
		printf("按任意键返回上一级");
		getch();
		return 1;
	}
	if(i==0)
	{
		printf("\n未查询到结果，按任意键返回上一级");
		getch();
		return 0;
	}
}

int SearchGender()
{
	int i=0;
	char aa;
	printf("请输入性别(M为男 F为女):");
	aa=getchar();
	fflush(stdin);
	printf("\n学号\t\t姓名\t性别\t年龄\t备注\t\n");
	for(p=stu;p<stu+N;p++)
	{
		if(aa==p->gender)
		{
			printf("%s\t%s\t%c\t%hd\t%s\n",p->id,p->name,p->gender,p->age,p->other);
			i++;
		}
	}
	if(i>0)
	{
		printf("\n查询到%d个结果\n",i);
		printf("按任意键返回上一级");
		getch();
		return 1;
	}
	if(i==0)
	{
		printf("\n未查询到结果，按任意键返回上一级");
		getch();
		return 0;
	}
}

int SearchAge()
{
	int i=0,ii;
	printf("请输入年龄:");
	scanf("%d",&ii);
	fflush(stdin);
	printf("\n学号\t\t姓名\t性别\t年龄\t备注\t\n");
	for(p=stu;p<stu+N;p++)
	{
		if(ii==p->age)
		{
			printf("%s\t%s\t%c\t%hd\t%s\n",p->id,p->name,p->gender,p->age,p->other);
			i++;
		}
	}
	if(i>0)
	{
		printf("\n查询到%d个结果\n",i);
		printf("按任意键返回上一级");
		getch();
		return 1;
	}
	if(i==0)
	{
		printf("\n未查询到结果，按任意键返回上一级");
		getch();
		return 0;
	}
}


void guipassword()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************");
	printf("\n\n\n\n\n\n                                          .--.\n");
	printf("                                         /.-. '----------.\n");
	printf("                                         \\'-' .--\"--\"\"-\"-'\n");
	printf("                                          '--'\n\n\n");
	printf("                                    请输入密码(关闭输入法)：");
}

void guipasswordagain()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息修改***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	printf("\n\n\n\n                                          .--.\n");
	printf("                                         /.-. '----------.\n");
	printf("                                         \\'-' .--\"--\"\"-\"-'\n");
	printf("                                          '--'\n\n\n");
	printf("                                    修改信息需要二次输入密码\n");
	printf("                                    请输入密码(关闭输入法)：");
}


void myputs(char a[]) //a是待输出字符串 b是每个字符输出间隔 bb是变色间隔 j是闪烁次数
{
	int i,len;
	char color1[9]={"color 07"},color2[9]={"color 05"};
	len=strlen(a);
	//system(color1);
	for(i=0;i<len;i++)
	{
		putchar(a[i]);
		Sleep(1);          //b
	}
	for(i=0;i<0;i++)       //i<j
	{
		system(color2);
		Sleep(5);         //bb
		system(color1);
		Sleep(5);         //bb
	}
	//printf("\n");
}

void guiaa_first()
{
	system("cls");
	myputs("\n       *******************************欢迎使用班级档案管理系统*******************************\n");
	myputs("\n                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║   学生基本信息录入   ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	myputs("                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║   学生基本信息显示   ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	myputs("                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║   学生基本信息保存   ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	myputs("                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║   学生基本信息删除   ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	myputs("                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║   学生基本信息修改   ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	myputs("                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║   学生基本信息查询   ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	myputs("                                      ╔══════════════════════╗                                      \n");
	myputs("                                      ║       退出系统       ║                                      \n");
	myputs("                                      ╚══════════════════════╝                                      \n");
	Sleep(5);
	system("color f7");
	Sleep(5);
	system("color f6");
	Sleep(5);
	system("color f5");
	Sleep(5);
	system("color f4");
	Sleep(5);
	system("color f3");
	Sleep(5);
	system("color f2");
	Sleep(5);
	system("color f1");
	Sleep(5);
	system("color f0");
	Sleep(5);
}

void guiaa()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiab()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiac()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiad()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiae()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiaf()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiag()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息录入   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息显示   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息保存   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息删除   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息修改   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                                      ║   学生基本信息查询   ║\n");
	printf("                                      ╚══════════════════════╝\n");
	printf("                                      ╔══════════════════════╗\n");
	printf("                               》》》 ║       退出系统       ║\n");
	printf("                                      ╚══════════════════════╝\n");
}

void guiba()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息录入***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	//flush=getch();
}

void guibb()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息显示***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	//flush=getch();
}

void guibc()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息保存***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	//flush=getch();
}

void guibd()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息删除***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	//flush=getch();
}

void guibe()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息修改***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	//flush=getch();
}


void guibfa()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	printf("\n\n\n\n                   ╔══════════════════════╗            ╔═══════════════╗\n");
	printf("                   ║   学生基本信息查询   ║     》》》 ║   按学号查询  ║\n");
	printf("                   ╚══════════════════════╝            ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按姓名查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按性别查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按年龄查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
}

void guibfb()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	printf("\n\n\n\n                   ╔══════════════════════╗            ╔═══════════════╗\n");
	printf("                   ║   学生基本信息查询   ║            ║   按学号查询  ║\n");
	printf("                   ╚══════════════════════╝            ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                》》》 ║   按姓名查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按性别查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按年龄查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
}

void guibfc()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	printf("\n\n\n\n                   ╔══════════════════════╗            ╔═══════════════╗\n");
	printf("                   ║   学生基本信息查询   ║            ║   按学号查询  ║\n");
	printf("                   ╚══════════════════════╝            ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按姓名查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                》》》 ║   按性别查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按年龄查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
}

void guibfd()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");
	printf("\n\n\n\n                   ╔══════════════════════╗            ╔═══════════════╗\n");
	printf("                   ║   学生基本信息查询   ║            ║   按学号查询  ║\n");
	printf("                   ╚══════════════════════╝            ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按姓名查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                       ║   按性别查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
	printf("                                                       ╔═══════════════╗\n");
	printf("                                                》》》 ║   按年龄查询  ║\n");
	printf("                                                       ╚═══════════════╝\n");
}


void guibg()
{
	int t=80;
	system("cls");
	{
		printf("\n\n\n                                               |`-:_\n");
		printf("                      ,----....____            |    `+.\n");
		printf("                     (             ````----....|___   |\n");
		printf("                      \\     _                      ````----....____\n");
		printf("                       \\    _)                                     ```---.._\n");
		printf("                      )`\\   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   \\`.\n");
		printf("                    -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n                                              |`-:_\n");
		printf("                     ,----....____            |    `+.\n");
		printf("                    (             ````----....|___   |\n");
		printf("                     \\     _                      ````----....____\n");
		printf("                      \\    _)                                     ```---.._\n");
		printf("                       \\                                                   \\\n");
		printf("                     )`.\\  )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("                   -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n                                             |`-:_\n");
		printf("                    ,----....____            |    `+.\n");
		printf("                   (             ````----....|___   |\n");
		printf("                    \\     _                      ````----....____\n");
		printf("                     \\    _)                                     ```---.._\n");
		printf("                    )`\\   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   \\`.\n");
		printf("                  -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n                                            |`-:_\n");
		printf("                   ,----....____            |    `+.\n");
		printf("                  (             ````----....|___   |\n");
		printf("                   \\     _                      ````----....____\n");
		printf("                    \\    _)                                     ```---.._\n");
		printf("                     \\                                                   \\\n");
		printf("                   )`.\\  )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("                 -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n                                           |`-:_\n");
		printf("                  ,----....____            |    `+.\n");
		printf("                 (             ````----....|___   |\n");
		printf("                  \\     _                      ````----....____\n");
		printf("                   \\    _)                                     ```---.._\n");
		printf("                  )`\\   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   \\`.\n");
		printf("                -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n\n                                          |`-:_\n");
		printf("                 ,----....____            |    `+.\n");
		printf("                (             ````----....|___   |\n");
		printf("                 \\     _                      ````----....____\n");
		printf("                 )\\.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("               -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n\n\n                                         |`-:_\n");
		printf("                ,----....____            |    `+.\n");
		printf("               (             ````----....|___   |\n");
		printf("                \\`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("              -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n\n\n\n                                        |`-:_\n");
		printf("               ,----....____            |    `+.\n");
		printf("               )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("             -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n\n\n\n\n                                       |`-:_\n");
		printf("              )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("            -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t);
	system("cls");
	{
		printf("\n\n\n\n\n\n\n\n             )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.\n");
		printf("           -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}Sleep(t/2);
	system("cls");
	{
		printf("\n\n\n\n\n\n\n\n\n           -'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'\n");
	}
	Sleep(t/2);
	system("cls");
	exit(0);
}


void guibfaa()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n\n");
	printf("                     ***********************按学号查询***********************      \n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");

}
void guibfbb()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n\n");
	printf("                     ***********************按姓名查询***********************      \n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");

}
void guibfcc()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n\n");
	printf("                     ***********************按性别查询***********************      \n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");

}
void guibfdd()
{
	system("cls");
	printf("\n       *******************************欢迎使用班级档案管理系统*******************************\n\n");
	printf("               ***************************学生基本信息查询***************************\n\n");
	printf("                     ***********************按年龄查询***********************      \n");
	printf("═══════════════════════════════════════════════════════════════════════════════════════════════════\n");

}


void Read_first()
{
	FILE *fp;
	int i;
	fp=fopen(DIR,"rb");
	if(fp==NULL)
	{
		printf("Something wrong happend when read the data file！\n system will exit...");
		Sleep(1000);
		exit(1);
	}
	for(i=0;i<N;i++)
	{
		fread(&stu[i],sizeof(struct STU),1,fp);
	}
	fclose(fp);
}

void Enter()
{
	int i;
	char id_t[20],gender_t; // _t的变量是temp
	short age_t;
	for(i=0;;i++)			//i是第一条空记录的位置
	{
		if(stu[i].age==0)
		{
			break;
		}
	}
	while(1)
	{
		printf("学号：");                           //输入学号时检查长度是否是12位 是否与已存在的重复
		gets(id_t);
		if(strlen(id_t)!=12)
		{
			printf("长度不是12位 请重新输入\n");
			continue;
		}
		if(Onlyid(id_t)==1)
		{
			strcpy(stu[i].id,id_t);
			break;
		}
		else
			printf("你输入的学号有重复 请重新输入\n");
	}
	
	printf("姓名：");                                      //输入姓名时要求不多
	gets(stu[i].name);
	

	while(1)
	{
		printf("性别(M为男，F为女)：");                    //输入性别时检查是否是'F'或'M'
		gender_t=getchar();
		fflush(stdin);
		if(gender_t=='M' || gender_t=='F')
		{
			stu[i].gender=gender_t;
			break;
		}
		else
		{
			printf("错误 请输入M或F\n");
		}
	}
	
	while(1)
	{
		printf("年龄：");                                  //检查输入的年龄是否在合理范围内
		scanf("%hd",&age_t);
		fflush(stdin);
		if(age_t<=0 || age_t>134)
			printf("请重新输入一个合理的年龄\n");
		else
		{
			stu[i].age=age_t;
			break;
		}
	}
	
	printf("备注：");                                      //输入的备注要求不多
	gets(stu[i].other);
	
	printf("录入完成，按任意键返回上一级");
	getch();
}

int Onlyid(char a[13])
{
	int i;
	for(i=0;stu[i].age!=0;i++)
	{
		if(strcmp(a,stu[i].id)==0)
			return 0;
	}
	return 1;
}

void Show()
{
	int i;
	if(stu[0].age != 0)
	{
		printf("学号\t\t姓名\t性别\t年龄\t备注\t\n");
		for(i=0;stu[i].age != 0;i++)
		{
			printf("%s\t%s\t%c\t%hd\t%s\n",stu[i].id,stu[i].name,stu[i].gender,stu[i].age,stu[i].other);
		}
	}
	else
	{
		printf("没有可显示的数据,按任意键返回上一级\n");
		getch();
		return;
	}
	printf("按任意键返回上一级");
	getch();
}

int Save()
{
	FILE *fp;
	int i;
	fp=fopen(DIR,"wb");
	if(fp==NULL)
	{
		printf("Something wrong happend when read the data file！");
		return 0;
	}
	for(i=0;i<N;i++)
	{
		fwrite(&stu[i],sizeof(struct STU),1,fp);
	}
	if(fclose(fp)==0)
	{
		printf("保存至data文件成功\n");
		printf("按任意键返回上一级");
		getch();
		return 1;
	}
}
int Delete()
{
	int i,j;
	char ch1,a[20];
	while(1)
	{
		printf("请输入你要删除的条目的学号：");
		gets(a);
		for(i=0;stu[i].age!=0;i++)
		{
			if(strcmp(a,stu[i].id)==0)
			{
				printf("\n学号：%s\n姓名：%s\n性别：%c\n年龄：%hd\n备注：%s\n\n",stu[i].id,stu[i].name,stu[i].gender,stu[i].age,stu[i].other);
				printf("确定要删除这条记录吗 Enter是 Esc否\n");
				ch1=getch();
				if(ch1==13)//Enter
				{
					for(j=i;j<N-1;j++)
					{
						strcpy(stu[j].id,stu[j+1].id);
						strcpy(stu[j].name,stu[j+1].name);
						stu[j].gender=stu[j+1].gender;
						stu[j].age=stu[j+1].age;
						strcpy(stu[j].other,stu[j+1].other);
					}
					printf("已删除这条记录\n");
					printf("按任意键返回上一级");
					getch();
					return 1;
				}
				else if(ch1==27)//Esc
				{
					printf("已取消删除这条记录，按任意键返回上一级");
					getch();
					return 1;
				}
			}
		}
		printf("未查找到匹配项 Enter重新输入 Esc退出\n");
		ch1=getch();
		if(ch1==13)//Enter
			continue;
		else if(ch1==27)//Esc
			return 1;
	}
}
void Change()
{
	int i;
	char YN,gender_t,a[20],id_t[20];
	short age_t;
	printf("请输入你要修改的条目的学号：");
	gets(a);
	for(i=0;stu[i].age!=0;i++)
	{
		if(strcmp(a,stu[i].id)==0)
		{
			printf("(按Enter修改 按任意字母键来查看下一条目且不修改)\n");
			printf("\n学号：%s \n",stu[i].id);
			YN=getch();
			if(YN==13)
			{
				printf("%s——>修改为：",stu[i].id);
				gets(id_t);
				if((Onlyid(id_t)==1)&&(strlen(id_t))==12)
				{
					strcpy(stu[i].id,id_t);
				}
				else
				{
					printf("无法修改 与已存在的学号重复或长度不为12位\n");
				}
			}
			if(YN==27)
				goto Flag_back;
			
			printf("\n姓名：%s\n",stu[i].name);
			YN=getch();
			if(YN==13)
			{
				printf("%s——>修改为：",stu[i].name);
				gets(stu[i].name);
			}
			if(YN==27)
				goto Flag_back;
			
			printf("\n性别：%c\n",stu[i].gender);
			YN=getch();
			if(YN==13)
			{
				printf("%c——>修改为(M或F)：",stu[i].gender);
				gender_t=getchar();
				fflush(stdin);
				if(gender_t=='M' || gender_t=='F')
				{
					stu[i].gender=gender_t;
				}
				else
				{
					printf("错误 输入的不是M或F \n");
				}
			}
			if(YN==27)
				goto Flag_back;
			
			printf("\n年龄：%hd\n",stu[i].age);
			YN=getch();
			if(YN==13)
			{
				printf("%hd——>修改为：",stu[i].age);
				scanf("%hd",&age_t);
				if(age_t<=0 || age_t>134)
					printf("输入的年龄不合理 原记录不做改变\n");
				else
				{
					stu[i].age=age_t;
				}
			}
			if(YN==27)
				goto Flag_back;
			
			printf("\n备注：%s\n",stu[i].other);
			YN=getch();
			if(YN==13)
			{
				printf("%s\n——>修改为：",stu[i].other);
				gets(stu[i].other);
				return;
			}
			printf("修改完成 按任意键返回上一级");
			getch();
			return;
		}
	}
	printf("未查找到匹配项\n");
	Flag_back:
	printf("按任意键返回上一级");
	getch();
	return;
}

void cypt(char a[])
{
	int i;
	for(i=0;a[i]!='\0';i++)
	{
		a[i]^=PASSCYPT;
	}
}

void cypt_struct()
{
	int i;
	for(i=0;stu[i].age!=0;i++)
	{
		cypt(stu[i].id);
		cypt(stu[i].name);
		stu[i].gender^=PASSCYPT;
		stu[i].age^=PASSCYPT;
		cypt(stu[i].other);
	}
}

void Read_first_and_encypt()
{
	FILE *fp;
	int i;
	fp=fopen(DIR,"rb");
	if(fp==NULL)
	{
		printf("Something wrong happend when read the data file！\n system will exit...");
		Sleep(1000);
		exit(1);
	}
	for(i=0;i<N;i++)
	{
		fread(&stu[i],sizeof(struct STU),1,fp);
	}
	fclose(fp);
	cypt_struct();
}

int Save_and_cypt()
{
	FILE *fp;
	int i;
	fp=fopen(DIR,"wb");
	if(fp==NULL)
	{
		printf("Something wrong happend when read the data file！");
		return 0;
	}
	cypt_struct();
	for(i=0;i<N;i++)
	{
		fwrite(&stu[i],sizeof(struct STU),1,fp);
	}
	if(fclose(fp)==0)
	{
		printf("保存至data文件成功\n");
		printf("按任意键返回上一级");
		getch();
		return 1;
	}
	cypt_struct();
}

void MagicPutc_an(char a)
{
	int i,j;
	srand((unsigned int)time(NULL));
	for(i=rand()%37,j=0;j<FLASH_TIME;i=(i+7)%37,j++)//i用于产生下标 j用于控制循环次数
	{
		putchar(alnum[i]);
		Sleep(SLEEP_TIME);
		putchar('\b');
	}
	putchar(a);
}

void MagicPuts_an(char a[])
{
	int i,len;
	len=strlen(a);
	for(i=0;i<len;i++)
	{
		if((a[i]>=40)&&(a[i]<=176))//按照GB2312的编码方式 一级汉字是从B0A1开始的 不存在B0A0 B1A0...D6A0 D7A0、B0FF B1FF...D5FF D6FF(一级汉字只到D7F9)
			MagicPutc_an(a[i]);
		else
			putchar(a[i]);
	}
}
