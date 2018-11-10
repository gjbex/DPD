/*!
 * @file
 * @author Geert Jan Bex (geertjan.bex@uhasselt.be)
 * @brief Application to check whether a string is a palindrome.
 * @mainpage Palindrome tester
 *
 * This application checks whether a string is a palindrome, that is,
 * a string that reads the same from left to right as from right to
 * left.  For example, `"radar"` is a palindrome, while `"Radar"`
 * is not.
 *
 * You can run the application on the command line with the string
 * you want to check as argument.
 *
 *     $ ./palindrome.exe  "radar"
 *     radar is a palindrome
 *
 *     $ ./palindrome.exe "Radar"
 *     Radar is not a palindrome
 *
 * Note that the empty string is considered a palindrome.
 */
#include <err.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*!
 * @def EXIT_CL_ARG_MISSING
 * @brief exit code for the application when not run with a single arguments
 *
 */
#define EXIT_CL_ARG_MISSING 1

bool is_palindrome(char str[]);

/*!
 * @brief application's main function
 */
int main(int argc, char *argv[]) {
    if (argc != 2)
        errx(EXIT_CL_ARG_MISSING,
             "### error: %s expect a string argument", argv[0]);
    printf("%s is %s palindrome\n",
           argv[1], is_palindrome(argv[1]) ? "a" : "not a");
    return EXIT_SUCCESS;
}

/*!
 * @brief checks whether the given string is a palindrome
 *
 * A string is a palindrome when it reads the same from left to
 * right and right to left. An empty string, as well as a string of
 * length 1 is considered a palindrome.
 *
 * Example:
 *
 *     char str[80] = "radar";
 *     if (is_palindrome(str))
 *         printf("yay, a palindrome!\n");
 *
 * Note that this is a recursive implementation, so you can expect
 * stack issues for very long strings.
 *
 * @param str string to check
 *
 * @returns true if the string is a palindrome, false otherwise.
 *
 */
bool is_palindrome(char str[]) {
    size_t length = strlen(str);
    if (length)
        if (str[0] != str[length])
            return false;
        else {
            str[length] = "\0";
            return is_palindrome(str[1]);
        }
    else
        return true;
}
