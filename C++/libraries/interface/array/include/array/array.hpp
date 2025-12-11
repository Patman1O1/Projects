#ifndef ARRAY_HPP
#define ARRAY_HPP

#include <memory>

namespace adt {
    template<class T, class Allocator = std::allocator<T>>
    class array {
    public:
        /* -----------------------------------------------Definitions------------------------------------------------ */
        using value_type = T;

        using allocator_type = Allocator;

        using size_type = std::size_t;

        using difference_type = std::ptrdiff_t;

        using reference = value_type&;

        using const_reference = const value_type&;

        using pointer = value_type*;

        using const_pointer = const value_type*;

    private:
        /* -------------------------------------------------Fields--------------------------------------------------- */
        pointer values;

        size_type size;

    public:
        /* --------------------------------------------Constant Iterator--------------------------------------------- */
        class const_iterator {
        public:
            /* ------------------------------------------Definitions------------------------------------------------- */
            using iterator_category = std::random_access_iterator_tag;

            using value_type = array::value_type;

            using difference_type = array::difference_type;

            using pointer = array::pointer;

            using const_pointer = array::const_pointer;

            using reference = array::reference;

            using const_reference = array::const_reference;

        private:
            /* ---------------------------------------------Fields--------------------------------------------------- */
            const_pointer ptr;

        public:
            /* ------------------------------------------Constructors------------------------------------------------ */
            constexpr const_iterator(void) noexcept { this->ptr = nullptr; }

            explicit constexpr const_iterator(const array& array) noexcept { this->ptr = array.values; }

            explicit constexpr const_iterator(array&& array) noexcept { this->ptr = array.values; }

            constexpr const_iterator(const const_iterator& other) noexcept { this->ptr = other.ptr; }

            constexpr const_iterator(const_iterator&& other) noexcept { this->ptr = other.ptr; other.ptr = nullptr; }

            /* --------------------------------------Overloaded Operators-------------------------------------------- */
            constexpr const_iterator& operator=(const const_iterator& other) noexcept = default;

            constexpr const_iterator& operator=(const_iterator&& other) noexcept = default;

            constexpr const_iterator& operator++(void) noexcept {

            }
        };

        class iterator {

        };
    };
} // namespace adt

#endif // ARRAY_HPP
