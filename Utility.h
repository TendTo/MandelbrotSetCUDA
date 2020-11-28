#ifndef __UTILITY
#define __UTILITY
#include <SFML/Graphics.hpp>

////////////////////////////////////////////////////////////
///
/// Overrides the << operator to print sf::Color,
/// printing the r g b and a values of the color variable
///
/// \param os  Left operand
/// \param c   Right operand
/// 
/// \return output stream
///
////////////////////////////////////////////////////////////
std::ostream& operator<<(std::ostream& os, const sf::Color& c)
{
	os << "r:" << c.r << " g:" << c.g << " b:" << c.b << " a:" << c.a;
	return os;
}
#endif // __UTILITY