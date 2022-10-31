OS := $(shell uname)
PWD := $(shell pwd)

CCCOLOR     = "\033[34m"
LINKCOLOR   = "\033[34;1m"
SRCCOLOR    = "\033[33m"
BINCOLOR    = "\033[37;1m"
MAKECOLOR   = "\033[32;1m"
ENDCOLOR    = "\033[0m"

QUIET_CC       = @printf '    %b %b\n' $(CCCOLOR)CC$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_AS       = @printf '    %b %b\n' $(CCCOLOR)AS$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_AR       = @printf '    %b %b\n' $(CCCOLOR)AR$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_LINK     = @printf '    %b %b\n' $(LINKCOLOR)LINK$(ENDCOLOR) $(BINCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_RM       = printf '    %b %b\n' $(CCCOLOR)RM$(ENDCOLOR) $(SRCCOLOR)"$(CLEAR_FILE)"$(ENDCOLOR) 1>&2;
QUIET_STRIP    = @printf '    %b %b\n' $(CCCOLOR)STRIP$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_OBJCOPY  = @printf '    %b %b\n' $(CCCOLOR)OBJCOPY$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_OBJDUMP  = @printf '    %b %b\n' $(CCCOLOR)OBJDUMP$(ENDCOLOR) $(SRCCOLOR)"$(OBJDUMP_FILE)"$(ENDCOLOR) 1>&2;
QUIET_NM	   = @printf '    %b %b\n' $(CCCOLOR)NM$(ENDCOLOR) $(SRCCOLOR)"$(NM_FILE)"$(ENDCOLOR) 1>&2;
QUIET_TAR      = @printf '    %b %b\n' $(CCCOLOR)TAR$(ENDCOLOR) $(SRCCOLOR)$<$(ENDCOLOR) 1>&2;
QUIET_DEP      = @printf '    %b %b\n' $(CCCOLOR)CC$(ENDCOLOR) $(SRCCOLOR)$(PWD)/Makefile$(ENDCOLOR) 1>&2;

# >>>> 实验环境设置
# ---------------------------------------------------------
export OS_LAB_ROOT=$(PWD)
export OS_LAB_ENV=$(OS_LAB_ROOT)/env
export OS_LAB_TOOLS=$(OS_LAB_ROOT)/tools

# >>>> 设置编译连接工具环境
# ---------------------------------------------------------
KERNEL_INCLUDE = ./include
BUILD = ./tools/build.sh

ifeq ($(OS), Linux)
	TARGET=
else ifeq ($(OS), Darwin)
	TARGET=i386-elf-
else
	exit -1;
endif

AS	= $(QUIET_AS)$(TARGET)as --32 -g  # -g为0.12新增
LD	= $(QUIET_LINK)$(TARGET)ld
AR	= $(QUIET_AR)$(TARGET)ar
STRIP	= $(QUIET_STRIP)$(TARGET)strip
OBJCOPY = $(QUIET_OBJCOPY)$(TARGET)objcopy
OBJDUMP = $(QUIET_OBJCOPY)$(TARGET)objdump
NM = $(QUIET_OBJCOPY)$(TARGET)nm

RM = $(QUIET_RM)rm
TAR = $(QUIET_TAR)tar

CC	= $(QUIET_CC)$(TARGET)gcc
CPP	= $(QUIET_CC)$(TARGET)cpp -nostdinc
DEP	= $(TARGET)cpp -nostdinc

# -s(去除): 输出文件中省略所有的符号信息
# -X,--discard-locals:删除所有本地临时符号
# -x,--discard-al:删除所有本地符号
# -M: --print-map:显示链接映射，用于诊断目的
# -Map=<mapfile>:	将链接映射输出到指定的文件
# -O <level>:对于非零的优化等级，ld将优化输出。此操作会比较耗时，应该在生成最终的结果时使用。
# -T <scriptfile>,--script=<scriptfile>:使用scriptfile作为链接器脚本。此脚本将替换ld的默认链接器脚本（而不是添加到其中），
#          因此脚本必须指定输出文件所需的所有内容。如果当前目录中不存在脚本文件，“ld”会在-L选项指定的目录中查找
#     -Ttext=<org>:使用指定的地址作为文本段的起始点
#     -Tdata=<org>:使用指定的地址作为数据段的起始点
#     -Tbss=<org>:使用指定的地址作为bss段的起始点
# -e <entry>:使用指定的符号作为程序的初始执行点
# -m <emulation>: 64位系统上编译32位程序时需要加elf_i386
LDFLAGS = -m elf_i386    # -M为0.12新增，会把所有过程信息答应出来。

# -c：(compile)只编译生成中间同名目标文件，不链接
# -o，(output)指定输出文件名，该文件为可执行文件，不加-o会默认生成a.out
# -g: 生成调试信息，以操作系统的本地格式(stabs,COFF,XCOFF,或 DWARF)产生调试信息。GDB可以利用这些调试信息工作。
#     -g0没有调试信息，
#     -g1最少的调试信息，返回跟踪等，无局部变量和函数信息；
#     -g2相当于-g，一般的调试信息包括行号，函数，外部变量；
#     -g3包括额外的信息，例如所有的宏定义等。
#     如果你用的GDB调试器，那么使用-ggdb选项。如果是其他调试器，则使用-g
# -gdwarflevel: 请求生成调试信息,同时用level指出需要多少信息.默认的level值是2.
#     Level 1输出最少量的信息,仅够在不打算调试的程序段内backtrace.包括函数和外部变量的描述,但是 没有局部变量和行号信息.
#     Level 3包含更多的信息,如程序中出现的所有宏定义.当使用`-g3'选项的时候,某些调试器支持 宏扩展.
# -gdwarf-version
#     以 DWARF 格式生成调试信息（如果支持）,version 的值可以是 2、3、4 或 5；大多数目标的默认版本是 5
#    （VxWorks、TPF 和 Darwin/Mac OS X 除外，它们默认为版本 2，以及 AIX，默认为版本 4）。
#     需要注意的是,在DWARF第2版中,有些端口需要并总是在unwind表中使用一些不冲突的DWARF 3扩展。
#     第4版可能需要GDB 7.0 和-fvar-tracking-assignments以获得最大利益。第五版需要GDB 8.0或更高版本。
#     GCC不再支持DWARF第1版,这与第2版及以后的版本有很大的不同,由于历史原因,其他一些与DWARF相关的选项,
#     如-fno-dwarf2-cfi-asm）在名称中保留对DWARF版本2的引用，但适用于DWARF当前支持的所有版本。
# -Wall: 打印警告，
# -w: 如屏蔽警告
# -E: 只运行 C 预编译器
# -S: 只激活预处理和编译，就是指把文件编译成为汇编代码。
# -O: 对代码进行优化，
#     -O0不优化（默认）
#     -O1或-O优化生成代码，不影响编译速度，并且会采用一些优化算法，降低代码大小并提高代码运行速度。
#     -O2进一步优化，会降低编译速度，但是除了包含-O1的优化算法之外，还会采用一些其他的优化算法来提高代码运行速度。
#     -Os，相当于-O2.5
#     -O3比O2进一步优化，会采取一些向量化算法，提高代码的并行执行程度，使之更充分地利用现代cpu的流水线和cache。
#        包括inline函数，阻止gcc会把没有参数的printf优化成puts
# -m32: 64位系统编译32位程序需要加
# -DMACRO 以字符串“1”定义 MACRO 宏。
# -DMACRO=DEFN 以字符串“DEFN”定义 MACRO 宏
# -IDIRECTORY 指定额外的头文件搜索路径DIRECTORY
# -LDIRECTORY 指定额外的函数库搜索路径DIRECTORY
# -lLIBRARY 连接时搜索指定的函数库LIBRARY
# -shared 生成共享目标文件，通常用在建立共享库时
# -static 禁止使用共享连接
# -share 此选项将尽量使用动态库，所以生成文件比较小，但是需要系统由动态库.
# -traditional 试图让编译器支持传统的C语言特性
# -UMACRO 取消对 MACRO 宏的定义
# -fstrength-reduce: 优化循环语句
# -fomit-frame-pointer: 对无需帧指针的函数不要把帧指针保留在寄存器中
# -fcombine-regs(去除): 不再被gcc支持
# -mstring-insns(去除): Linus本人增加的选项(gcc中没有)
# -fno-builtin(新增): 不使用C语言的内建函数
# -fno-stack-protector: 禁用栈保护，默认提供栈保护，仅在gcc 4.x及以上版本支持
# -nostdinc: 使编译器不再系统缺省的头文件目录里面找头文件,一般和-I联合使用,明确限定头文件的位置
# -nostdin C++: 规定不在g++指定的标准路经中搜索,但仍在其他路径中搜索,.此选项在创libg++库使用
# --strip: 除去行号信息、重定位信息、调试段、typchk 段、注释段、文件头以及所有或部分符号表。

# we should use -fno-stack-protector with gcc 4.3
ifeq ($(OS), Linux)
	CFLAGS  = -g -O0 -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce -w #-Wall
else ifeq ($(OS), Darwin)
	#CFLAGS  = -gdwarf-2 -g3 -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce -w #-Wall
	CFLAGS  = -g -O0 -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce -w #-Wall
else
	exit -1;
endif

# ---------------------------------------------------------

# >>>> Qemu配置，可根据实际安装环境进行定制
# ---------------------------------------------------------
ifeq ($(OS), Linux)
	QEMU_HOME=/usr/local/Cellar/qemu/7.1.0/bin
	QEMU=$(QEMU_HOME)/qemu-system-i386
else ifeq ($(OS), Darwin)
	QEMU_HOME=/usr/local/Cellar/qemu/7.1.0/bin
	QEMU=$(QEMU_HOME)/qemu-system-i386
else
	exit -1;
endif


# ---------------------------------------------------------

# >>>> Bochs配置，可根据实际安装环境进行定制
# ---------------------------------------------------------
ifeq ($(OS), Linux)
	BOCHS_HOME=/home/todd/.local/bochs-i386
	BOCHS_DISP_LIB=x
	BOCHS_KEYBOARD=x11-pc-de.map
else ifeq ($(OS), Darwin)
	BOCHS_HOME=/usr/local/Cellar/bochs/2.6.11-x86
	BOCHS_DISP_LIB=sdl2
	BOCHS_KEYBOARD=sdl2-pc-de.map
else
	exit -1;
endif

export BOCHS_DISP_LIB BOCHS_KEYBOARD
export BXSHARE=$(BOCHS_HOME)/share/bochs
BOCHS=$(BOCHS_HOME)/bin/bochs
BOCHS_RC=$(OS_LAB_ENV)/bochs
# ---------------------------------------------------------

# >>>> VM configuration
# ---------------------------------------------------------
VM_CFG = tools/vm.cfg
# ---------------------------------------------------------

# ---------------------------------------------------------

# >>>> Tool for specify root device & swap device
# ---------------------------------------------------------
SETROOTDEV = tools/setrootdev.sh
SETSWAPDEV = tools/setswapdev.sh
# ---------------------------------------------------------

# >>>> Specify the Rootfs Image file
# ---------------------------------------------------------
HDA_IMG = hdc-0.11.img
FLP_IMG = rootimage-0.11
RAM_IMG = rootram.img
# ---------------------------------------------------------

gcc_version=${(4.4)}
