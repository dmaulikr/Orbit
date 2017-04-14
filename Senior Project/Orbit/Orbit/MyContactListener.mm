//
//  MyContactListener.m
//  Box2DPong
//
//  Created by Ray Wenderlich on 2/18/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "MyContactListener.h"

MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact) {
    Entity * entityA = static_cast<Entity* >(contact->GetFixtureA()->GetBody()->GetUserData());
    Entity * entityB = static_cast<Entity *>(contact->GetFixtureB()->GetBody()->GetUserData());
    
    EntitySide sideA = entityA.entitySide & (ENTITY_SIDE_ENEMY | ENTITY_SIDE_SELF);
    EntitySide sideB = entityB.entitySide & (ENTITY_SIDE_ENEMY | ENTITY_SIDE_SELF);
    
    if (entityA.entityType == ENTITY_TYPE_NONE || entityB.entityType == ENTITY_TYPE_NONE) {
        return;
    }
    
    if (sideA != sideB) {
        if (entityA.entityType != ENTITY_TYPE_WALL) {
            entityA.isValid = NO;
        }
        
        if (entityB.entityType != ENTITY_TYPE_WALL) {
            entityB.isValid = NO;
        }
    }
    
    /*if (entityA.entityType == ENTITY_TYPE_CIRCLE || entityB.entityType == ENTITY_TYPE_CIRCLE) {
        if (entityA.entityType == ENTITY_TYPE_NONE || entityB.entityType == ENTITY_TYPE_NONE) {
            return;
        }
   //     if (entityA.entityType != ENTITY_TYPE_CIRCLE) {
            entityA.isValid = NO;
   //     }
        
   //     if (entityB.entityType != ENTITY_TYPE_CIRCLE) {
            entityB.isValid = NO;
   //     }
    }*/
    
    if (entityA.entityType == ENTITY_TYPE_NONE) {
        NSLog(@"Entity None");
    } else if (entityA.entityType == ENTITY_TYPE_TRIANGLE) {
        NSLog(@"Entity Triangle");
    } else if (entityA.entityType == ENTITY_TYPE_SQUARE) {
        NSLog(@"Entity Square");
    } else if (entityA.entityType == ENTITY_TYPE_LINE) {
        NSLog(@"Entity Line");
    } else if (entityA.entityType == ENTITY_TYPE_CIRCLE) {
        NSLog(@"Entity Circle");
    } else if (entityA.entityType == ENTITY_TYPE_PLUS) {
        NSLog(@"Entity Plus");
    } else if (entityA.entityType == ENTITY_TYPE_WALL) {
        NSLog(@"Entity Wall");
    }
            
    
    if (entityB.entityType == ENTITY_TYPE_NONE)
        NSLog(@"Entity None");
    else if (entityB.entityType == ENTITY_TYPE_TRIANGLE)
        NSLog(@"Entity Triangle");
    else if (entityB.entityType == ENTITY_TYPE_SQUARE)
        NSLog(@"Entity Square");
    else if (entityB.entityType == ENTITY_TYPE_LINE)
        NSLog(@"Entity Line");
    else if (entityB.entityType == ENTITY_TYPE_CIRCLE)
        NSLog(@"Entity Circle");
    else if (entityB.entityType == ENTITY_TYPE_PLUS)
        NSLog(@"Entity Plus");
    else  if (entityB.entityType == ENTITY_TYPE_WALL)
        NSLog(@"Entity Wall");
    
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    //MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    //_contacts.push_back(myContact);
 //   NSLog(@"BeginContact");
}

void MyContactListener::EndContact(b2Contact* contact) {
    
    /*MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }*/
    
  //  NSLog(@"EndContact");
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}

void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}

