char code[] = "<insert_here>";

int main(int argc, char **argv)
{
	  int (*func)();
	    func = (int (*)()) code;
	      (int)(*func)();
}
