CC = cc
CFLAGS = -Wall -Wextra -Werror
AR = ar
ARFLAGS = rcs
RM = rm -f

NAME = get_next_line.a
BONUS_NAME = get_next_line_bonus.a

MANDATORY_SRCS = get_next_line.c get_next_line_utils.c
MANDATORY_OBJS = $(MANDATORY_SRCS:.c=.o)

BONUS_SRCS = get_next_line_bonus.c get_next_line_utils_bonus.c
BONUS_OBJS = $(BONUS_SRCS:.c=.o)

all: $(NAME)

$(NAME): $(MANDATORY_OBJS)
	$(AR) $(ARFLAGS) $(NAME) $(MANDATORY_OBJS)

bonus: $(BONUS_NAME)

$(BONUS_NAME): $(BONUS_OBJS)
	$(AR) $(ARFLAGS) $(BONUS_NAME) $(BONUS_OBJS)

clean:
	$(RM) $(MANDATORY_OBJS) $(BONUS_OBJS)

fclean: clean
	$(RM) $(NAME) $(BONUS_NAME)

re: fclean all

.PHONY: all bonus clean fclean re
