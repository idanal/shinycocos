/*
    ShinyCocos - ruby bindings for the cocos2d-iphone game framework
    Copyright (C) 2009, Rolando Abarca M.

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

#import "SC_common.h"
#import "SC_AtlasSpriteManager.h"
#import "SC_AtlasSprite.h"
#import "SC_CocosNode.h"

VALUE rb_cAtlasSpriteManager;

VALUE rb_cAtlasSpriteManager_s_Sprite_Manager_With_File(int argc, VALUE *argv, VALUE klass) {
	AtlasSpriteManager *manager;
	if (argc < 1 || argc > 2)
		rb_raise(rb_eArgError, "invalid number of arguments");
	
	Check_Type(argv[0], T_STRING);
	NSString *file = [NSString stringWithCString:STR2CSTR(argv[0]) encoding:NSUTF8StringEncoding];
	if (argc == 1) {
		manager = [AtlasSpriteManager spriteManagerWithFile:file];
	} else {
		Check_Type(argv[1], T_HASH);
		VALUE cap = rb_hash_aref(argv[1], ID2SYM(rb_intern("capacity")));
		if (cap == Qnil)
			rb_raise(rb_eArgError, "no :capacity key in hash");
		manager = [AtlasSpriteManager spriteManagerWithFile:file capacity:FIX2INT(cap)];
	}
	cocos_holder *ptr = ALLOC(cocos_holder);
	ptr->_obj = manager;
	VALUE obj = common_init(klass, ptr, NO);
	rb_hash_aset(rb_object_hash, INT2FIX((long)manager), obj);
	return obj;
}

VALUE rb_cAtlasSpriteManager_create_sprite(VALUE obj, VALUE rb_rect) {
	cocos_holder *ptr;
	Data_Get_Struct(obj, cocos_holder, ptr);
	CGRect rect = common_sc_make_rect(rb_rect);
	// create the sprite
	AtlasSprite* sprite = [GET_OBJC(ptr) createSpriteWithRect:rect];
	// return the sprite as a ruby object
	cocos_holder *ptr2;
	ptr2 = ALLOC(cocos_holder);
	ptr2->_obj = sprite;
	VALUE ret = common_init(rb_cAtlasSprite, ptr2, NO);
	rb_hash_aset(rb_object_hash, INT2FIX((long)sprite), ret);
	return ret;
}

void init_rb_cAtlasSpriteManager() {
	rb_cAtlasSpriteManager = rb_define_class_under(rb_mCocos2D, "AtlasSpriteManager", rb_cCocosNode);
	rb_define_singleton_method(rb_cAtlasSpriteManager, "manager_with_file", rb_cAtlasSpriteManager_s_Sprite_Manager_With_File, -1);
	rb_define_method(rb_cAtlasSpriteManager, "create_sprite", rb_cAtlasSpriteManager_create_sprite, 1);
}