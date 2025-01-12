.. _sec-dev-memoryManagement:

*****************
Memory Management
*****************

To avoid memory leaks, it is recommended to use smart pointers and the RAII (Resource Acquisition is initialization; see https://github.com/isocpp/CppCoreGuidelines/blob/master/CppCoreGuidelines.md#Rr-raii ). Until the C++11 standard is used in PELE, with the ``std::unique_ptr`` and other smart pointers (such as ``std::shared_ptr``), it is recommended to use the `Boost Smart Pointers <http://www.boost.org/doc/libs/1_36_0/libs/smart_ptr/smart_ptr.htm>`__ and the ``ScopedPtr`` class added to PELE (in :file:`Tools/ScopedPtr.h`).

If the kind of object used do not clearly reveal ownership information, make it clear in the documentation if a function takes ownership or not from the objects passed by pointer.


ScopedPtr
=========

This class allows passing it a pointer to an object, and it will take care of deeleting that object once the ScopedPtr object goes out of scope. This avoid leaking resources if the delete for the pointer is accidentally forgotten in the code (in the case of several return points, for example) or in case an exception is thrown.

The typical scenario is:

1. Create the object and put it under the ScopedPtr control.
2. Get access to the managed pointer with the ``get()`` member function.
3. Let exiting the current block to call the destructor of ScopedPtr, which in turn takes care of deleting the pointed object.

Example:

.. code-block:: c++

  ScopedPtr<Topology> linkTopology(new Topology());

  ...

  Topology* tmpPtr = linkTopology.get();

  ...

  return;

Notice that ScopedPtr uses, by default, ``delete`` operator for deleting the pointed objects. This means that it does not work with allocated arrays. Besides, there are cases where specialized deletion is required, such as when deleting a vector of pointed objects, in which case we may want to also delete the pointed objects. For those cases, the ``ScopedPtr`` allows providing our own deleter (the default deleter is ``ScopedPtrDefaultDelete``); a deleter, following the interface of ``std::unique_ptr``, is a class implementing the `void operator()(T* ptr) const`` interface.

For example, to do a deep delete of a vector of pointed elements:

.. code-block:: c++

  template <class T>
  struct VectorDeleter {
    void operator()(std::vector<T*> *ptr) const {
      if (ptr) {
        // Deallocates all the objects pointed in the vector
	for(unsigned int i =0; i< ptr->size();++i)
	{
	  if((*ptr)[i])
	  {
	    delete (*ptr)[i];
	  }
	}
	ptr->clear();

	delete ptr;
      }
    }
  };

  {
    ScopedPtr<std::vector<Atom*>, VectorDeleter> myvector(new std::vector<Atom*>);

    ...
  }


Sometimes, the ownership of the object needs to be transferred, in which case it is best to use the ``release()`` member function, which returns the managed pointer, and stops managing that object, so that it won't be deleted when the ``ScopedPtr`` is destroyed. On the other hand, if one wants to destroy the object now, instead of waiting to leaving the current scope, the member function ``reset()`` does exactly so.

.. code-block:: c++

  ScopedPtr<Atom*> atom1(new Atom());
  ScopedPtr<Atom*> tempAtom(new Atom());

  ...

  createMacroStructure(atom1.release());

  ...
  
  tempAtom.reset();

  ...

