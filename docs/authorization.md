# Authorization
┌────────────────────┐                                                             
│                    │                                                             
│        Club        │┼──────────────────────────────────────────────────┐         
│                    │                                                   │         
└────────────────────┘                                                   │         
           ┼                                                            ╱│╲        
           │                                                    ┌─────────────────┐
           │                                                    │Membership       │
           │                                                    │Start date       │
           │                                                    │End date         │
           │                                                    └─────────────────┘
           │                                                             ┼         
           │                                                             │         
           │                                                             │         
          ╱│╲                                                            │         
 ┌──────────────────┐                                                    ┼         
 │Role              │                                           ┌─────────────────┐
 │Identifier        │                                           │                 │
 │Name              │                                           │      User       │
 │                  │╲         ╱┌──────────────────┐╲          ╱│      Name       │
 │[ ] Create        │───────────│    Permission    │────────────│  Current Club   │
 │[ ] Read          │╱         ╲└──────────────────┘╱          ╲│                 │
 │[ ] Update        │                                           │                 │
 │[ ] Delete        │                                           └─────────────────┘
 └──────────────────┘                                                                                                                      
 
 ```
 mix phx.gen.live Authorization Role roles identifier:string name:string description:text  create:boolean read:boolean update:boolean delete:boolean club_id:references:clubs
 ```